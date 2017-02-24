require 'spec_helper'
require 'json'

RSpec.describe MercadoPago::Client, type: :model do
  SPEC_ROOT = File.expand_path('../', File.dirname(__FILE__))

  let(:payment_method){ double('payment_method', preferred_client_id: 1, preferred_client_secret: 1) }

  let(:order) { double('order', payment_method: payment_method, number: 'testorder', line_items: [], ship_total: 1000) }
  let(:url_callbacks) { {success: 'url', failure: 'url', pending: 'url'} }
  let(:payment_method) { double :payment_method, id: 1, preferred_client_id: 'app id', preferred_client_secret: 'app secret' }
  let(:payment) {double :payment, payment_method:payment_method, id:1, identifier:"fruta" }

  let(:login_json_response){ File.open("#{SPEC_ROOT}/../fixtures/authenticated.json").read }
  let(:preferences_json_response){ File.open("#{SPEC_ROOT}/../fixtures/preferences_created.json").read }
  let(:client) { MercadoPago::Client.new(payment_method) }

  describe '#initialize' do
    it "doesn't raise error with all params" do
      expect {client}.not_to raise_error
    end
  end

  describe '#authenticate' do
    context 'On success' do
      let(:http_response) {
        response = double('response')
        allow(response).to receive(:code).and_return 200
        allow(response).to receive(:to_str).and_return login_json_response
        response
      }
      let(:js_response) { JSON.parse(http_response) }

      before(:each) do
        allow(RestClient).to receive(:post).and_return( http_response )
      end

      it 'returns a response object' do
        expect(client.authenticate).to eq(js_response)
      end

      it '#errors returns empty array' do
        client.authenticate
        expect(client.errors).to be_empty
      end

      it 'sets the access token' do
        client.authenticate
        expect(client.auth_response['access_token']).to eq('TU_ACCESS_TOKEN')
      end
    end

    context 'On failure' do
      let(:bad_request_response) do
        response = double('response')
        allow(response).to receive(:code).and_return 400
        allow(response).to receive(:to_str).and_return ""
        response
      end

      before(:each) do  
        allow(RestClient).to receive(:post).and_raise(RestClient::Exception.new "foo")
      end

      it 'raise exception on invalid authentication' do
        expect { client.authenticate }.to raise_error(RuntimeError) do |error|
          expect(client.errors).to include(I18n.t(:authentication_error, scope: :mercado_pago))
        end
      end
    end
  end

  describe '#check_payment_status' do
    let(:collection) { {} }
    let(:expected_response) { {results: [collection: collection]} }

    before :each do
      allow(subject).to receive(:send_search_request).with({:external_reference => payment.id}).and_return(expected_response)
      allow(subject).to receive(:check_status).with(payment, {})
    end
  end

  describe '#create_preferences' do
    context 'On success' do
      let(:preferences) { {foo:"bar"} }

      before(:each) do
        response = double('response')
        allow(response).to receive(:code).and_return(200, 201)
        allow(response).to receive(:to_str).and_return(login_json_response, preferences_json_response)
        allow(RestClient).to receive(:post).exactly(2).times { response }

        client.authenticate
      end

      it 'return value should not be nil' do
        response = client.create_preferences(preferences)
        expect(response).to be_truthy
      end

      it '#redirect_url returns offsite checkout url' do
        client.create_preferences(preferences)
        expect(client.redirect_url).to be_present
        expect(client.redirect_url).to eq('https://www.mercadopago.com/checkout/pay?pref_id=identificador_de_la_preferencia')
      end
    end

    context 'on failure' do
      before(:each) do
        expect(RestClient).to receive(:post).exactly(2).times do
          if not @is_second_time
            @is_second_time = true
            "{}"
          else
            raise RestClient::Exception.new "foo"
          end
        end
        client.authenticate
      end

      let(:preferences) { {foo:"bar"} }

      it 'throws exception and populate errors' do
        expect {client.create_preferences(preferences)}.to raise_error(RuntimeError) do |variable|
          expect(client.errors).to include(I18n.t(:authentication_error, scope: :mercado_pago))
        end
      end
    end
  end
end

require 'json'

class MercadoPago::Client
  module API
    def redirect_url
      point_key = sandbox ? 'sandbox_init_point' : 'init_point'
      @preferences_response[point_key]
    end

    private

    def notifications_url(operation_id)
      sandbox_part = sandbox ? 'sandbox/' : ''
      "https://api.mercadolibre.com/#{sandbox_part}collections/notifications/#{operation_id}"
    end

    def search_url
      sandbox_part = sandbox ? 'sandbox/' : ''
      "https://api.mercadolibre.com/#{sandbox_part}collections/search"
    end

    def create_url(url, params = {})
      uri = URI(url)
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    def preferences_url(token)
      create_url('https://api.mercadolibre.com/checkout/preferences', access_token: token)
    end

    def sandbox
      Rails.application.try(:secrets).try(:[], :mercadopago).try(:[], :sandbox)
    end

    def get(url, request_options = {}, options = {})
      response = RestClient.get(url, request_options)
      JSON.parse(response)
    # TODO: add class to rescue
    rescue => e
      raise e unless options[:quiet]
    end
  end
end

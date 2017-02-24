require 'spec_helper'

RSpec.describe Spree::MercadoPagoController, type: :controller do
  describe "#ipn" do
    let(:operation_id) { "op123" }

    context "for valid notifications" do
      let(:use_case) { double("use_case") }

      it "handles notification and returns success" do
        allow(MercadoPago::HandleReceivedNotification).to receive(:new).and_return(use_case)
        expect(use_case).to receive(:process!)

        spree_post :ipn, { id: operation_id, topic: "payment" }
        expect(response).to be_success

        notification = MercadoPago::Notification.order(:created_at).last
        expect(notification.topic).to eq("payment")
        expect(notification.operation_id).to eq(operation_id)
      end
    end

    context "for invalid notification" do
      it "responds with invalid request" do
        spree_post :ipn, { id: operation_id, topic: "nonexistent_topic" }
        expect(response).to be_bad_request
      end
    end
  end
end

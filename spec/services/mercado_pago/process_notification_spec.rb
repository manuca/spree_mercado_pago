require 'spec_helper'

module MercadoPago
  describe ProcessNotification do
    let(:order)   { FactoryGirl.create(:completed_order_with_pending_payment) }
    let(:payment) { order.payments.first }

    let(:operation_id) { "op123" }
    let(:notification) { Notification.new(topic: "payment", operation_id: operation_id) }
    let(:operation_info) do
      {
        "collection" => {
          "external_reference" => order.payments.first.number,
          "status" => "approved"
        }
      }
    end
    

    describe "with valid operation_info" do
      # The first payment method of this kind will be picked by the process task
      before do
        fake_client = double("fake_client")
        fake_payment_method = double("fake_payment_method", provider: fake_client)
        allow(Spree::PaymentMethod::MercadoPago).to receive(:first).and_return(fake_payment_method)
        allow(fake_client).to receive(:get_operation_info).with(operation_id).
          and_return(operation_info)
        payment.pend!
        expect(payment.state).to eq("pending")
      end

      describe "#process!" do
        it "completes payment for approved payment" do
          ProcessNotification.new(notification).process!
          payment.reload
          expect(payment.state).to eq("completed")
        end

        it "fails payment for rejected payment" do
          operation_info["collection"]["status"] = "rejected"
          ProcessNotification.new(notification).process!
          payment.reload
          expect(payment.state).to eq("failed")
        end

        it "voids payment for rejected payment" do
          operation_info["collection"]["status"] = "cancelled"
          ProcessNotification.new(notification).process!
          payment.reload
          expect(payment.state).to eq("void")
        end

        it "pends payment for pending payment" do
          operation_info["collection"]["status"] = "pending"
          ProcessNotification.new(notification).process!
          payment.reload
          expect(payment.state).to eq("pending")
        end
      end
    end
    
    describe "with invalid operation_info" do
      # The first payment method of this kind will be picked by the process task
      before do
        fake_client = double("fake_client")
        fake_payment_method = double("fake_payment_method", provider: fake_client)
        allow(Spree::PaymentMethod::MercadoPago).to receive(:first).and_return(fake_payment_method)
        allow(fake_client).to receive(:get_operation_info).with(operation_id).
          and_return(nil)
        payment.pend!
        expect(payment.state).to eq("pending")
      end

      describe "#process!" do
        
        it "does not crash" do
          ProcessNotification.new(notification).process!
        end
      end
    end
  end
end

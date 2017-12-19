module MercadoPago
  class OrderPreferencesBuilder
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
    include Spree::ProductsHelper

    def initialize(order, payment, callback_urls, payer_data = nil)
      @order         = order
      @payment       = payment
      @callback_urls = callback_urls
      @payer_data    = payer_data
    end

    def preferences_hash
      {
        external_reference: @payment.number,
        back_urls: @callback_urls,
        payer: @payer_data,
        items: generate_items
      }
    end

    private

    def generate_items
      items = []

      items += generate_items_from_line_items
      items += generate_items_from_adjustments
      items += generate_items_from_shipments

      items
    end

    def generate_items_from_shipments
      @order.shipments.collect do |shipment|
        {
          title: shipment.shipping_method.name,
          unit_price: shipment.cost.to_f + shipment.adjustment_total.to_f,
          quantity: 1
        }
      end
    end

    def generate_items_from_line_items
      @order.line_items.collect do |line_item|
        {
          title: line_item_description_text(line_item.variant.product.name),
          unit_price: line_item.price.to_f,
          quantity: line_item.quantity
        }
      end
    end

    def generate_items_from_adjustments
      @order.adjustments.eligible.collect do |adjustment|
        {
          title: line_item_description_text(adjustment.label),
          unit_price: adjustment.amount.to_f,
          quantity: 1
        }
      end
    end
  end
end

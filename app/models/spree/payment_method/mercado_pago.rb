module Spree
  class PaymentMethod::MercadoPago < PaymentMethod

    def payment_profiles_supported?
      false
    end

    def provider_class
      ::MercadoPago::Client
    end

    def provider(additional_options = {})
      @provider ||= begin
                      options = { sandbox: preferred_sandbox }
                      client = provider_class.new(self, options.merge(additional_options))
                      client.authenticate
                      client
                    end
    end

    def source_required?
      false
    end

    def auto_capture?
      false
    end

    def preferred_sandbox
      Rails.application.try(:secrets).try(:[], :mercadopago).try(:[], "sandbox")
    end

    ## Admin options

    def can_void?(payment)
      payment.state != 'void'
    end

    def actions
      %w{void}
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end

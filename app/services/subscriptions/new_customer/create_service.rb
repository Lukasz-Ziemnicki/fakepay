# frozen_string_literal: true

module Subscriptions
  module NewCustomer
    class CreateService < Subscriptions::BaseCreateService
      attr_reader :customer

      def call!
        super

        customer
      end

      protected

      def create_customer_subscription!
        @customer = Customer.create!(params)
      end

      def fakepay_billing_params
        billing_details.merge!(amount: subscription.price_per_month_in_cents)
      end

      def fakepay_sync!
        response = Fakepay::CreatePaymentService.new(fakepay_billing_params).call!

        update_fakepay_token(response)
      end

      def subscription!
        @subscription = Subscription.find(params.dig(:customer_subscriptions_attributes, 0, :subscription_id))
      end

      def update_fakepay_token(fakepay_response)
        customer.update(fakepay_token: fakepay_response['token'])
      end
    end
  end
end

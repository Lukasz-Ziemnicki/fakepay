# frozen_string_literal: true

module Subscriptions
  module ExistingCustomer
    class CreateService < Subscriptions::BaseCreateService
      attr_reader :customer, :customer_subscription

      def call!
        super

        customer_subscription
      end

      protected

      def create_customer_subscription!
        customer!

        @customer_subscription = CustomerSubscription.create!(params)
      end

      def customer!
        @customer = Customer.find(params[:customer_id])
      end

      def fakepay_billing_params
        billing_details.merge!({
                                 amount: subscription.price_per_month_in_cents,
                                 token: customer.fakepay_token
                               })
      end

      def fakepay_sync!
        Fakepay::CreatePaymentService.new(fakepay_billing_params).call!
      end

      def subscription!
        @subscription = Subscription.find(params[:subscription_id])
      end
    end
  end
end

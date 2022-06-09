# frozen_string_literal: true

module Fakepay
  class RenewPaymentService < BaseService
    attr_reader :date

    def initialize(date)
      @date = date

      super()
    end

    #
    # It's not performant enough
    # TO DO: It would be nice to enqueue script with job queue, like Sidekiq or DelayedJob
    #
    def call!
      CustomerSubscription.active
                          .with_customer_and_subscription
                          .where(renewed_at: last_payment_date)
                          .find_each do |customer_subscription|
        renew!(customer_subscription)
      end
    end

    private

    def last_payment_date
      date - 1.month
    end

    def renew!(customer_subscription)
      CustomerSubscription.transaction do
        customer_subscription.update!(renewed_at: Time.current)

        fakepay_api_adapter.purchase({
                                       amount: customer_subscription.price_per_month_in_cents,
                                       token: customer_subscription.fakepay_token
                                     })
      end
    end
  end
end

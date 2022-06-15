# frozen_string_literal: true

module Subscriptions
  class BaseCreateService
    attr_reader :billing_details, :params, :subscription

    def initialize(params: {}, billing_details: {})
      @billing_details = billing_details
      @params = params
    end

    def call!
      ActiveRecord::Base.transaction do
        subscription!

        create_customer_subscription!

        fakepay_sync!
      end
    end

    protected

    def create_customer_subscription!
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def subscription!
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def fakepay_sync!
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end

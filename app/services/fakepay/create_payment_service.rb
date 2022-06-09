# frozen_string_literal: true

module Fakepay
  class CreatePaymentService < BaseService
    attr_reader :billing_params

    def initialize(billing_params)
      @billing_params = billing_params

      super()
    end

    def call!
      fakepay_api_adapter.purchase(billing_params)
    end
  end
end

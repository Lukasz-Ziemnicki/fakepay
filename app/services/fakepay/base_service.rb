# frozen_string_literal: true

module Fakepay
  class BaseService
    attr_reader :fakepay_api_adapter

    def initialize
      @fakepay_api_adapter = Api::Fakepay::Adapter.instance
    end

    def call!
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end

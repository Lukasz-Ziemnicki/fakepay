# frozen_string_literal: true

module Api
  module Fakepay
    class Adapter < Api::Base
      ERROR_CODES_WITH_MESSAGES = {
        1_000_001 => 'Invalid credit card number',
        1_000_002 => 'Insufficient funds',
        1_000_003 => 'CVV failure',
        1_000_004 => 'Expired card',
        1_000_005 => 'Invalid zip code',
        1_000_006 => 'Invalid purchase amount',
        1_000_007 => 'Invalid token',
        1_000_008 => 'Invalid params'
      }.freeze

      def purchase(payment_details)
        post(
          path: '/purchase',
          headers: headers,
          body: payment_details
        )
      end

      protected

      def base_url_with_scheme
        ENV.fetch('FAKEPAY_BASE_URL_WITH_SCHEME', 'https://www.fakepay.io')
      end

      def fake_api_token
        ENV.fetch('FAKEPAY_API_KEY', '460011f9a17f6d2c8d8b3ef3068240')
      end

      def headers
        {
          'Authorization' => "Token token=#{fake_api_token}",
          'Content-Type' => 'application/json'
        }
      end

      def invoke(method: nil, path: nil, headers: {}, body: {}, query: {})
        response = super(method: method, path: path, headers: headers, body: body, query: query)

        raise Api::Fakepay::ResponseError, ERROR_CODES_WITH_MESSAGES[response['error_code']] unless response['success']

        response
      end
    end
  end
end

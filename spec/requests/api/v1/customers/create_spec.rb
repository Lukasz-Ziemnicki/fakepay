# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CustomersController#create', type: :request do
  subject(:request) { post(api_v1_customers_path, params: params, headers: { 'Accept' => "application/json" }) }

  let(:subscription) { create(:subscription) }

  let(:params) do
    {
      customer: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        zip_code: Faker::Address.zip_code,
        customer_subscriptions_attributes: [
          {
            subscription_id: subscription.id
          }
        ]
      },
      billing_details: {
        card_number: Faker::Finance.credit_card,
        expiration_month: rand(1..12),
        expiration_year: rand(2022..2024),
        cvv: rand(100..999),
        zip_code: Faker::Address.zip_code
      }
    }
  end

  let(:fakepay_token) { Faker::Internet.device_token }

  let(:fakepay_request_stub) do
    stub_request(:post, URI.join(ENV.fetch('FAKEPAY_BASE_URL_WITH_SCHEME', 'https://www.fakepay.io'), '/purchase'))
      .to_return headers: { 'Content-Type' => 'application/json' },
                 body: { 'success' => true, 'token' => fakepay_token }.to_json
  end

  before do
    subscription

    fakepay_request_stub
  end

  context 'New customer with new customer subscription' do
    context 'successful response' do
      it { expect { subject }.to(change { CustomerSubscription.count }.by(1)) }
      it { expect { subject }.to(change { Customer.count }.by(1)) }

      it 'returns 201 http status code' do
        subject

        expect(response.status).to eq 201
      end

      it 'returns location of the created resource' do
        subject

        expect(response.location).to eq api_v1_customer_path(Customer.first)
      end
    end

    context 'error response' do
      context 'one of attributes invalid' do
        let(:params) do
          {
            customer: {
              first_name: nil,
              last_name: Faker::Name.last_name,
              street: Faker::Address.street_address,
              city: Faker::Address.city,
              zip_code: Faker::Address.zip_code,
              customer_subscriptions_attributes: [
                {
                  subscription_id: subscription.id
                }
              ]
            },
            billing_details: {
              card_number: Faker::Finance.credit_card,
              expiration_month: rand(1..12),
              expiration_year: rand(2022..2024),
              cvv: rand(100..999),
              zip_code: Faker::Address.zip_code
            }
          }
        end

        it { expect { subject }.not_to(change { CustomerSubscription.count }) }
        it { expect { subject }.not_to(change { Customer.count }) }

        it 'returns 422 http status code' do
          subject

          expect(response.status).to eq 422
        end

        it 'returns body with error message' do
          subject

          expect(JSON.parse(response.body)).to eq({
            errors: {
              first_name: ["can't be blank"]
            }
          }.deep_stringify_keys!)
        end
      end

      context 'invalid subscription_id' do
        let(:params) do
          {
            customer: {
              first_name: nil,
              last_name: Faker::Name.last_name,
              street: Faker::Address.street_address,
              city: Faker::Address.city,
              zip_code: Faker::Address.zip_code,
              customer_subscriptions_attributes: [
                {
                  subscription_id: 'invalid-id'
                }
              ]
            },
            billing_details: {
              card_number: Faker::Finance.credit_card,
              expiration_month: rand(1..12),
              expiration_year: rand(2022..2024),
              cvv: rand(100..999),
              zip_code: Faker::Address.zip_code
            }
          }
        end

        it { expect { subject }.not_to(change { CustomerSubscription.count }) }
        it { expect { subject }.not_to(change { Customer.count }) }

        it 'returns 404 http status code' do
          subject

          expect(response.status).to eq 404
        end
      end

      context 'external service error' do
        let(:error_code) { 1_000_003 }

        let(:fakepay_request_stub) do
          stub_request(:post, URI.join(ENV.fetch('FAKEPAY_BASE_URL_WITH_SCHEME', 'https://www.fakepay.io'), '/purchase'))
            .to_return headers: { 'Content-Type' => 'application/json' },
                       body: { 'success' => false, 'error_code' => error_code }.to_json
        end

        it { expect { subject }.not_to(change { CustomerSubscription.count }) }
        it { expect { subject }.not_to(change { Customer.count }) }

        it 'returns 422 http status code' do
          subject

          expect(response.status).to eq 422
        end

        it 'returns body with error message' do
          subject

          expect(JSON.parse(response.body)).to eq({
            errors: {
              base: [Api::Fakepay::Adapter::ERROR_CODES_WITH_MESSAGES[error_code]]
            }
          }.deep_stringify_keys!)
        end
      end
    end
  end
end

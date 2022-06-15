# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CustomerSubscriptionsController#create', type: :request do
  subject(:request) { post(api_v1_customer_subscriptions_path, params: params, headers: { 'Accept' => "application/json" }) }

  let(:subscription) { create(:subscription) }
  let(:customer) { create(:customer, :with_token) }

  let(:params) do
    {
      customer_subscription: {
        subscription_id: subscription.id,
        customer_id: customer.id
      }
    }
  end

  let(:fakepay_request_stub) do
    stub_request(:post, URI.join(ENV.fetch('FAKEPAY_BASE_URL_WITH_SCHEME', 'https://www.fakepay.io'), '/purchase'))
      .to_return headers: { 'Content-Type' => 'application/json' },
                 body: { 'success' => true }.to_json
  end

  before { fakepay_request_stub }

  context 'New customer subscription for existing customer' do
    context 'successful response' do
      it { expect { subject }.to change { CustomerSubscription.count }.by(1) }

      it 'returns 201 http status code' do
        subject

        expect(response.status).to eq 201
      end

      it 'returns location of the created resource' do
        subject

        expect(response.location).to eq api_v1_customer_subscription_path(CustomerSubscription.first)
      end
    end

    context 'invalid customer_id' do
      let(:params) do
        {
          customer_subscription: {
            subscription_id: subscription.id,
            customer_id: 'invalid-customer-id'
          }
        }
      end

      it { expect { subject }.not_to(change { CustomerSubscription.count }) }

      it 'returns 404 http status code' do
        subject

        expect(response.status).to eq 404
      end
    end

    context 'invalid subscription_id' do
      let(:params) do
        {
          customer_subscription: {
            subscription_id: 'invalid-subscription-id',
            customer_id: customer.id
          }
        }
      end

      it { expect { subject }.not_to(change { CustomerSubscription.count }) }

      it 'returns 404 http status code' do
        subject

        expect(response.status).to eq 404
      end
    end

    context 'existing customer subscription' do
      before { create(:customer_subscription, customer: customer, subscription: subscription) }

      it { expect { subject }.not_to(change { CustomerSubscription.count }) }

      it 'returns 422 http status code' do
        subject

        expect(response.status).to eq 422
      end

      it 'returns body with error messages' do
        subject

        expect(JSON.parse(response.body)).to eq ({
          errors: {
            subscription: ['has already been taken']
          }
        }.deep_stringify_keys!)
      end
    end
  end
end

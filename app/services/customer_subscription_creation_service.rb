# frozen_string_literal: true

class CustomerSubscriptionCreationService
  attr_reader :billing_params, :customer_subscription_params

  def initialize(customer_subscription_params: {}, billing_params: {})
    @customer_subscription_params = customer_subscription_params
    @billing_params = billing_params
  end

  def call!
    CustomerSubscription.transaction do
      customer = find_or_create_customer!

      customer_subscription = create_customer_subscription!(customer)

      response = Fakepay::CreatePaymentService.new(billing_params_with_amount).call!

      update_fakepay_token(customer, response)

      customer_subscription
    end
  end

  private

  def billing_params_with_amount
    subscription = Subscription.find(customer_subscription_params['subscription_id'])

    billing_params.merge(amount: subscription.price_per_month_in_cents)
  end

  def create_customer_subscription!(customer)
    params = customer_subscription_params.slice(:subscription_id).merge(customer_id: customer.id)

    CustomerSubscription.create!(params.merge(renewed_at: Time.current))
  end

  def find_or_create_customer!
    customer_id = customer_subscription_params['customer_id']

    if customer_id.present?
      Customer.find(customer_id)
    else
      Customer.create!(customer_subscription_params['customer'])
    end
  end

  def update_fakepay_token(customer, fakepay_response)
    customer.update(fakepay_token: fakepay_response['token'])
  end
end

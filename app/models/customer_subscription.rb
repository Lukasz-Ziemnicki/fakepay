# frozen_string_literal: true

# == Schema Information
#
# Table name: customer_subscriptions
#
#  id              :uuid             not null, primary key
#  status          :integer          default("active"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :uuid             not null
#  subscription_id :uuid             not null
#
# Indexes
#
#  index_customer_subscriptions_on_customer_id      (customer_id)
#  index_customer_subscriptions_on_subscription_id  (subscription_id)
#  index_on_customer_id_subscription_id             (customer_id,subscription_id) UNIQUE
#
class CustomerSubscription < ApplicationRecord
  delegate :price_per_month_in_cents, to: :subscription
  delegate :fakepay_token, to: :customer

  #
  # Associations
  #
  belongs_to :customer
  belongs_to :subscription

  #
  # Validations
  #
  validates :customer,
            uniqueness: { scope: :subscription }

  #
  # Scopes
  #
  scope :with_customer_and_subscription, -> { includes(:subscription, :customer) }

  #
  #
  # Enums
  #
  enum status: {
    ceased: 0,
    active: 1
  }

  accepts_nested_attributes_for :customer
end

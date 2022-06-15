# frozen_string_literal: true

# == Schema Information
#
# Table name: customer_subscriptions
#
#  id              :uuid             not null, primary key
#  renewed_at      :date
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
FactoryBot.define do
  factory :customer_subscription do
    status { :active }

    customer
    subscription
  end
end

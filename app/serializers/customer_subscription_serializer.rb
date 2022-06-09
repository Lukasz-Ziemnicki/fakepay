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
class CustomerSubscriptionSerializer < BaseSerializer
  fields :created_at

  association :customer, blueprint: CustomerSerializer
  association :subscription, blueprint: SubscriptionSerializer
end

# frozen_string_literal: true

class SeedSubscriptions < ActiveRecord::Migration[7.0]
  FAKEPAY_SUBSCRIPTIONS = [
    {
      name: 'Bronze Box',
      price_per_month_in_cents: 1999
    },
    {
      name: 'Silver Box',
      price_per_month_in_cents: 4900
    },
    {
      name: 'Gold Box',
      price_per_month_in_cents: 9900
    }
  ].freeze

  def up
    Subscription.transaction do
      FAKEPAY_SUBSCRIPTIONS.each { |subscription| Subscription.create!(subscription) }
    end
  end

  def down
    Subscription.transaction do
      FAKEPAY_SUBSCRIPTIONS.each { |subscription| Subscription.find_by(name: subscription[:name]).destroy! }
    end
  end
end

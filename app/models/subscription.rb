# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id                       :uuid             not null, primary key
#  name                     :string(255)      not null
#  price_per_month_in_cents :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_name  (name) UNIQUE
#
class Subscription < ApplicationRecord
  #
  # Assocations
  #
  has_many :customer_subscriptions, dependent: :restrict_with_exception
  has_many :customers, through: :customer_subscriptions

  #
  # Validations
  #
  validates :price_per_month_in_cents,
            :name,
            presence: true
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id            :uuid             not null, primary key
#  city          :string(255)      not null
#  fakepay_token :string
#  first_name    :string(255)      not null
#  last_name     :string(255)      not null
#  street        :string(255)      not null
#  zip_code      :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    street { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }

    trait :with_token do
      fakepay_token { Faker::Internet.device_token }
    end
  end
end

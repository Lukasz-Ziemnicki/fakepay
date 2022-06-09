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
#
class CustomerSerializer < BaseSerializer
  fields :created_at,
         :city,
         :first_name,
         :last_name,
         :street,
         :zip_code
end

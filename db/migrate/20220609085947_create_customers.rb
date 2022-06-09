# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :first_name, null: false, limit: 255
      t.string :last_name, null: false, limit: 255
      t.string :city, null: false, limit: 255
      t.string :street, null: false, limit: 255
      t.string :zip_code, null: false, limit: 255
      t.string :fakepay_token

      t.timestamps
    end
  end
end

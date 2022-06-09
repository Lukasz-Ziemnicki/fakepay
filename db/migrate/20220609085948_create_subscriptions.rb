# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.string :name, null: false, limit: 255
      t.integer :price_per_month_in_cents, null: false

      t.timestamps
    end

    add_index :subscriptions, :name, unique: true
  end
end

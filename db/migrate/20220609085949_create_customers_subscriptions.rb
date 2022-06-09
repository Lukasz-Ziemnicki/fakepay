# frozen_string_literal: true

class CreateCustomersSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_subscriptions, id: :uuid do |t|
      t.uuid :customer_id, null: false, index: true
      t.uuid :subscription_id, null: false, index: true
      t.date :renewed_at
      t.integer :status, null: false, default: '1'

      t.timestamps
    end

    add_index :customer_subscriptions,
              %i[customer_id subscription_id],
              name: 'index_on_customer_id_subscription_id',
              unique: true
  end
end

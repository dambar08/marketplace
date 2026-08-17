class CreateFulfillments < ActiveRecord::Migration[8.1]
  def change
    create_table :fulfillments do |t|
      t.string :tracking_numbers, array: true, default: []
      t.string :tracking_links, array: true, default: []
      t.string :provider_id
      t.datetime :packed_at
      t.datetime :shipped_at
      t.datetime :delivered_at
      t.datetime :cancelled_at
      t.timestamps
    end
  end
end

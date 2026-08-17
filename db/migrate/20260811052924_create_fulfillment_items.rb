class CreateFulfillmentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :fulfillment_items do |t|
      t.belongs_to :line_item, null: false
      t.integer :quantity, null: false, default: 0
      t.timestamps
    end
  end
end

class AddFulfillmentToFulfillmentItems < ActiveRecord::Migration[8.1]
  def change
    add_reference :fulfillment_items, :fulfillment, null: false, index: true
  end
end

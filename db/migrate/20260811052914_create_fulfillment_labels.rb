class CreateFulfillmentLabels < ActiveRecord::Migration[8.1]
  def change
    create_table :fulfillment_labels do |t|
      t.string :tracking_number, null: false
      t.string :tracking_url, null: false
      t.string :label_url
      t.belongs_to :fulfillment, null: false
      t.timestamps
    end
  end
end

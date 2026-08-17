class CreateShippingOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_options do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.belongs_to :shipping_option_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end

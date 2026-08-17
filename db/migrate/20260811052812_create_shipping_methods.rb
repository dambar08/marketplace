class CreateShippingMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_methods do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :amount, null: false, precision: 10, scale: 2, default: 0.0
      t.decimal :total, null: false, precision: 10, scale: 2, default: 0.0
      t.decimal :tax_total, null: false, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end

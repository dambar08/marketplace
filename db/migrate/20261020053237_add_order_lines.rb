class AddOrderLines < ActiveRecord::Migration[8.1]
  def change
    change_table :orders do |t|
      t.decimal :subtotal, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total, precision: 10, scale: 2, null: false, default: 0
    end

    change_table :order_items do |t|
      t.references :order, null: false, index: true
      t.string :title, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
    end
  end
end

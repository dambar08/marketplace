class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.decimal :subtotal, null: false, precision: 10, scale: 2, default: 0.0
      t.decimal :total, null: false, precision: 10, scale: 2, default: 0.0
      t.decimal :original_item_total, null: false, precision: 10, scale: 2, default: 0.0
      t.decimal :original_item_subtotal, null: false, precision: 10, scale: 2, default: 0.0      
      t.timestamps
    end
  end
end

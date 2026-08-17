class CreateCartLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_line_items do |t|
      t.string :title, null: false
      t.string :subtitle, null: true
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, null: false, precision: 10, scale: 2
      t.decimal :total, null: false, precision: 10, scale: 2
      t.belongs_to :product_variant, null: true
      t.timestamps
    end
  end
end
class CreateProductVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :product_variants do |t|
      t.belongs_to :product, null: false
      t.string :title, null: false
      t.string :sku, null: true
      t.integer :inventory_quantity
      t.boolean :allow_backorder
      t.jsonb :options, null: false, default: {}
      t.timestamps
    end
  end
end

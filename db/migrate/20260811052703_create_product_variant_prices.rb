class CreateProductVariantPrices < ActiveRecord::Migration[8.1]
  def change
    create_table :product_variant_prices do |t|
      t.belongs_to :product_variant, null: false
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.string :currency, null: false
      t.timestamps
    end
  end
end

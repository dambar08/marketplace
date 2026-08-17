class CreateProductOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :product_options do |t|
      t.belongs_to :product, null: false
      t.string :title, null: false
      t.string :values, null: false, default: []
      t.timestamps
    end
  end
end

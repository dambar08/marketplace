class CreateProductImages < ActiveRecord::Migration[8.1]
  def change
    create_table :product_images do |t|
      t.timestamps
    end
  end
end

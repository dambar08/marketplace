class CreateShippingOptionTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_option_types do |t|
      t.string :label, null: false
      t.string :description
      t.timestamps
    end
  end
end

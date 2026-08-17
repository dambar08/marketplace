class CreatePromotions < ActiveRecord::Migration[8.1]
  def change
    create_table :promotions do |t|
      t.string :code, null: false
      t.string :type
      t.decimal :value, null: false, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end

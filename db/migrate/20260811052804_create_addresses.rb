class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :company
      t.string :address_1, null: false
      t.string :address_2
      t.string :city, null: false
      t.string :province
      t.string :postal_code, null: false
      t.string :country_code, null: false
      t.string :phone
      t.timestamps
    end
  end
end

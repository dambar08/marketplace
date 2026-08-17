class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.string :subtitle, null: true
      t.jsonb :metadata, null: false, default: {}
      t.text :description
      t.string :slug, null: false
      t.timestamps
    end

    add_index :products, :slug, unique: true
  end
end

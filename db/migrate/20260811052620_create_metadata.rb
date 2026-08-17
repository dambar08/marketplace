class CreateMetadata < ActiveRecord::Migration[8.1]
  def change
    create_table :metadata do |t|
      t.string :key, null: false
      t.string :value
      t.timestamps
    end

    add_index :metadata, :key, unique: true
  end
end

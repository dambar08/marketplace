class DropCartLineItems < ActiveRecord::Migration[8.1]
  def change
    drop_table :cart_line_items
  end
end

class AddUserToCartsAndOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :carts, :user, null: true, index: true
    add_reference :orders, :user, null: true, index: true
  end
end

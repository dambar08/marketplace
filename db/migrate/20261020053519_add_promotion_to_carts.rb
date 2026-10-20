class AddPromotionToCarts < ActiveRecord::Migration[8.1]
  def change
    add_reference :carts, :promotion, null: true, index: true
  end
end

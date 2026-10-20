class Cart < ApplicationRecord
  has_many :line_items, class_name: "LineItem", dependent: :destroy

  def add_line(title:, unit_price:, quantity: 1, subtitle: nil)
    line_items.create!(
      title: title,
      subtitle: subtitle,
      quantity: quantity,
      unit_price: unit_price,
      total: quantity * unit_price
    )
    refresh_totals!
  end

  def change_line_quantity(line, quantity)
    owned = line_items.find(line.id)
    owned.update!(quantity: quantity, total: quantity * owned.unit_price)
    refresh_totals!
  end

  def remove_line(line)
    line_items.find(line.id).destroy!
    refresh_totals!
  end

  private

  def refresh_totals!
    sum = line_items.sum(:total)
    update!(
      subtotal: sum,
      total: sum,
      original_item_subtotal: sum,
      original_item_total: sum
    )
  end
end

class Cart < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :promotion, optional: true
  has_many :line_items, class_name: "LineItem", dependent: :destroy

  def add_line(title:, unit_price:, quantity: 1)
    line_items.create!(
      title: title,
      quantity: quantity,
      unit_price: unit_price,
      total: quantity * unit_price
    )
    refresh_totals!
  end

  def change_line_quantity(line, quantity)
    owned = find_line(line)
    owned.update!(quantity: quantity, total: quantity * owned.unit_price)
    refresh_totals!
  end

  def remove_line(line)
    find_line(line).destroy!
    line_items.reset
    refresh_totals!
  end

  def apply_promotion(promotion)
    update!(promotion: promotion)
    refresh_totals!
  end

  private

  def find_line(line)
    if line_items.loaded?
      line_items.target.find { |candidate| candidate.id == line.id } ||
        raise(ActiveRecord::RecordNotFound)
    else
      line_items.find(line.id)
    end
  end

  def refresh_totals!
    sum = line_items.sum(:total)
    adjustment = promotion&.value || 0
    update!(
      subtotal: sum,
      total: [ sum - adjustment, 0 ].max,
      original_item_subtotal: sum,
      original_item_total: sum
    )
  end
end

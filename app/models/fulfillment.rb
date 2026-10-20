class Fulfillment < ApplicationRecord
  has_many :fulfillment_items, dependent: :destroy
  has_many :line_items, through: :fulfillment_items
  has_many :fulfillment_labels, dependent: :destroy

  def self.awaiting
    where(shipped_at: nil, delivered_at: nil, cancelled_at: nil)
  end

  def status_label
    return "Cancelled" if cancelled_at
    return "Delivered" if delivered_at
    return "Shipped" if shipped_at
    return "Packed" if packed_at

    "Awaiting shipment"
  end

  def mark(next_status, tracking_number: nil)
    case next_status
    when "packed"
      update!(packed_at: Time.current)
    when "shipped"
      number = tracking_number.presence || tracking_numbers.first
      if number.blank?
        errors.add(:tracking_number, "is required to mark shipped")
        raise ActiveRecord::RecordInvalid, self
      end
      update!(shipped_at: Time.current, tracking_numbers: [ number ])
    when "delivered"
      update!(delivered_at: Time.current)
    when "cancelled"
      update!(cancelled_at: Time.current)
    end
  end
end

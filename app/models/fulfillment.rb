class Fulfillment < ApplicationRecord
  has_many :fulfillment_items, dependent: :destroy
  has_many :line_items, through: :fulfillment_items
  has_many :fulfillment_labels, dependent: :destroy

  validates :tracking_numbers, presence: true
end

class FulfillmentItem < ApplicationRecord
  belongs_to :fulfillment
  belongs_to :line_item
end

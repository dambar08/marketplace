class ShipppingOptionType < ApplicationRecord
  belongs_to :shipping_option, class_name: "ShippingOption", foreign_key: "shipping_option_id"
end

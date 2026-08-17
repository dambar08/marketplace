class ShippingOption < ApplicationRecord
  has_one :type, class_name: "ShippingOptionType", foreign_key: "shipping_option_type_id", dependent: :destroy
end

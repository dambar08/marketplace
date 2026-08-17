class Cart < ApplicationRecord
  has_many :line_items, class_name: "LineItem", dependent: :destroy
end

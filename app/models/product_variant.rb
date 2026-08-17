class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :prices, class_name: "ProductVariantPrice", dependent: :destroy
end

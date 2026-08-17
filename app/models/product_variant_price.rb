class ProductVariantPrice < ApplicationRecord
  belongs_to :product_variant
  belongs_to :product, through: :product_variant
end

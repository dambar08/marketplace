class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_many :variants, class_name: "ProductVariant", dependent: :destroy
  has_many :images, class_name: "ProductImage", dependent: :destroy
  has_many :options, class_name: "ProductOption", dependent: :destroy
  has_one_attached :thumbnail
end

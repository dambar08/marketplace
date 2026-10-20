class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: "OrderItem", dependent: :destroy
end

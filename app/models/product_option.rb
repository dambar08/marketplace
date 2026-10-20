class ProductOption < ApplicationRecord
  belongs_to :product

  def values=(raw)
    list = raw.is_a?(String) ? raw.split(",") : Array(raw)
    super(list.map { |value| value.to_s.strip }.reject(&:blank?))
  end
end

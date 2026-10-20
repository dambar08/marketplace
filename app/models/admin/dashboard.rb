class Admin::Dashboard
  LOW_STOCK_THRESHOLD = 5
  RECENT_LIMIT = 5

  def product_count
    Product.count
  end

  def variant_count
    ProductVariant.count
  end

  def user_count
    User.count
  end

  def order_count
    Order.count
  end

  def cart_count
    Cart.count
  end

  def promotion_count
    Promotion.count
  end

  def awaiting_shipment_count
    Fulfillment.where(shipped_at: nil, delivered_at: nil, cancelled_at: nil).count
  end

  def products_without_variants_count
    products_without_variants.count
  end

  def products_without_variants
    Product.where.missing(:variants).order(:title)
  end

  def captured_by_currency
    PaymentCollection.group(:currency_code).sum(:captured_amount)
  end

  def payment_status_counts
    PaymentCollection.group(:status).count.sort_by { |_status, count| -count }.to_h
  end

  def recent_products
    Product.includes(:variants).order(created_at: :desc).limit(RECENT_LIMIT)
  end

  def recent_payments
    PaymentCollection.order(created_at: :desc).limit(RECENT_LIMIT)
  end

  def recent_users
    User.order(created_at: :desc).limit(RECENT_LIMIT)
  end

  def low_stock_variants
    ProductVariant.includes(:product)
      .where(inventory_quantity: ..LOW_STOCK_THRESHOLD)
      .order(:inventory_quantity, :title)
      .limit(8)
  end
end

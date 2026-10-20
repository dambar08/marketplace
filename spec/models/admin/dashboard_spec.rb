require "rails_helper"

RSpec.describe Admin::Dashboard do
  it "summarizes catalog, payments, and low stock" do
    product = Product.create!(title: "Ceramic mug")
    ProductVariant.create!(product: product, title: "Blue", inventory_quantity: 2)
    Product.create!(title: "Unfinished listing")
    create(:user, email_address: "buyer@example.com")
    Order.create!
    Cart.create!
    Promotion.create!(code: "WELCOME")
    Fulfillment.create!(tracking_numbers: [ "1Z999" ])
    PaymentCollection.create!(
      amount: 42.5,
      captured_amount: 40,
      currency_code: "USD",
      status: "captured"
    )
    PaymentCollection.create!(
      amount: 10,
      currency_code: "USD",
      status: "pending"
    )

    dashboard = described_class.new

    expect(dashboard.product_count).to eq(2)
    expect(dashboard.variant_count).to eq(1)
    expect(dashboard.products_without_variants_count).to eq(1)
    expect(dashboard.order_count).to eq(1)
    expect(dashboard.cart_count).to eq(1)
    expect(dashboard.promotion_count).to eq(1)
    expect(dashboard.awaiting_shipment_count).to eq(1)
    expect(dashboard.captured_by_currency["USD"]).to eq(BigDecimal("40"))
    expect(dashboard.payment_status_counts).to eq({ "captured" => 1, "pending" => 1 })
    expect(dashboard.recent_products.first.title).to eq("Unfinished listing")
    expect(dashboard.low_stock_variants.sole.title).to eq("Blue")
  end

  it "ignores shipped fulfillments and stocked variants" do
    product = Product.create!(title: "Tote")
    ProductVariant.create!(product: product, title: "Natural", inventory_quantity: 20)
    Fulfillment.create!(tracking_numbers: [ "1Z111" ], shipped_at: Time.current)

    dashboard = described_class.new

    expect(dashboard.awaiting_shipment_count).to eq(0)
    expect(dashboard.low_stock_variants).to be_empty
  end
end

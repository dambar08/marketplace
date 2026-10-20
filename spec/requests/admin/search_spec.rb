require "rails_helper"

RSpec.describe "Admin search and filters" do
  before do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
  end

  it "searches customers by email address" do
    create(:user, email_address: "buyer@example.com")
    create(:user, email_address: "other@example.com")

    get admin_customers_path(q: "buyer")

    expect(response.body).to include("buyer@example.com")
    expect(response.body).not_to include("other@example.com")
  end

  it "filters customers who are admins" do
    create(:user, email_address: "buyer@example.com", admin: false)

    get admin_customers_path(filter: "admins")

    expect(response.body).to include("admin@example.com")
    expect(response.body).not_to include("buyer@example.com")
  end

  it "searches promotions by code" do
    Promotion.create!(code: "WELCOME", value: 5)
    Promotion.create!(code: "SPRING", value: 8)

    get admin_promotions_path(q: "WEL")

    expect(response.body).to include("WELCOME")
    expect(response.body).not_to include("SPRING")
  end

  it "searches payments by status" do
    PaymentCollection.create!(amount: 10, currency_code: "USD", status: "captured")
    PaymentCollection.create!(amount: 4, currency_code: "USD", status: "pending")

    get admin_payments_path(q: "capt")

    expect(response.body).to include("USD 10.00")
    expect(response.body).not_to include("USD 4.00")
  end

  it "filters payments by status" do
    PaymentCollection.create!(amount: 10, currency_code: "USD", status: "captured")
    PaymentCollection.create!(amount: 4, currency_code: "USD", status: "pending")

    get admin_payments_path(status: "pending")

    expect(response.body).to include("USD 4.00")
    expect(response.body).not_to include("USD 10.00")
  end

  it "searches fulfillments by status" do
    shipped = Fulfillment.create!(shipped_at: Time.current, tracking_numbers: [ "1Z" ])
    waiting = Fulfillment.create!

    get admin_fulfillments_path(q: "Awaiting")

    expect(response.body).to include("Fulfillment #{waiting.id}")
    expect(response.body).to include("Awaiting shipment")
    expect(response.body).not_to include("Fulfillment #{shipped.id}")
  end

  it "searches orders by id" do
    keep = Order.create!
    drop = Order.create!

    get admin_orders_path(q: keep.id)

    expect(response.body).to include("Order #{keep.id}")
    expect(response.body).not_to include("Order #{drop.id}")
  end

  it "searches carts by id" do
    keep = Cart.create!
    drop = Cart.create!

    get admin_carts_path(q: keep.id)

    expect(response.body).to include("Cart #{keep.id}")
    expect(response.body).not_to include("Cart #{drop.id}")
  end

  it "filters products with no variants" do
    Product.create!(title: "Unfinished listing")
    finished = Product.create!(title: "Linen shirt")
    finished.variants.create!(title: "Blue", sku: "LINEN-BLU")

    get admin_products_path(filter: "without_variants")

    expect(response.body).to include("Unfinished listing")
    expect(response.body).not_to include("Linen shirt")
  end

  it "filters variants at or below 5 in stock" do
    product = Product.create!(title: "Linen shirt")
    product.variants.create!(title: "Blue", sku: "LINEN-BLU", inventory_quantity: 2)
    product.variants.create!(title: "Natural", sku: "LINEN-NAT", inventory_quantity: 20)

    get admin_products_path(filter: "low_stock")

    expect(response.body).to include("Blue")
    expect(response.body).to include("Stock 2")
    expect(response.body).not_to include("Natural")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

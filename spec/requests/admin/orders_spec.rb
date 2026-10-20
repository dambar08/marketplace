require "rails_helper"

RSpec.describe "Admin orders" do
  it "lists orders" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    order = Order.create!

    get admin_orders_path

    expect(response.body).to include("Order #{order.id}")
  end

  it "says when an order has no lines" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    order = Order.create!

    get admin_order_path(order)

    expect(response.body).to include("No lines")
  end

  it "shows order lines, snapshotted prices, and totals" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    order = Order.create!(subtotal: 30, total: 30)
    order.items.create!(title: "Mug", quantity: 2, unit_price: 10, total: 20)

    get admin_order_path(order)

    expect(response.body).to include("Mug")
    expect(response.body).to include("Qty 2")
    expect(response.body).to include("10.00")
    expect(response.body).to include("Line 20.00")
    expect(response.body).to include("Subtotal 30.00")
    expect(response.body).to include("Total 30.00")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

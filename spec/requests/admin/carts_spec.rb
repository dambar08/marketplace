require "rails_helper"

RSpec.describe "Admin carts" do
  it "opens a cart and shows snapshotted lines and totals" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    cart = Cart.create!
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)

    get admin_cart_path(cart)

    expect(response.body).to include("Mug")
    expect(response.body).to include("10.00")
    expect(response.body).to include("20.00")
    expect(response.body).to include("Subtotal 20.00")
    expect(response.body).to include("Total 20.00")
  end

  it "attaches one code and drops the total by that value" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    cart = Cart.create!
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    promotion = Promotion.create!(code: "WELCOME", value: 5)

    patch admin_cart_path(cart), params: { promotion_id: promotion.id }
    follow_redirect!

    expect(response.body).to include("Code WELCOME")
    expect(response.body).to include("Subtotal 20.00")
    expect(response.body).to include("Total 15.00")
  end

  it "removes the code and restores the line sum" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    cart = Cart.create!
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    cart.apply_promotion(Promotion.create!(code: "WELCOME", value: 5))

    patch admin_cart_path(cart), params: { promotion_id: "" }
    follow_redirect!

    expect(response.body).not_to include("Code WELCOME")
    expect(response.body).to include("Total 20.00")
  end

  it "takes the full promotion value off the cart total" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    cart = Cart.create!
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    promotion = Promotion.create!(code: "BIG", value: 25)

    patch admin_cart_path(cart), params: { promotion_id: promotion.id }
    follow_redirect!

    expect(response.body).to include("Total -5.00")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

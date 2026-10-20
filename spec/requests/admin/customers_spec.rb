require "rails_helper"

RSpec.describe "Admin customers" do
  it "lists customers by email address" do
    create(:user, email_address: "admin@example.com", admin: true)
    create(:user, email_address: "buyer@example.com", admin: false)
    sign_in_as("admin@example.com")

    get admin_customers_path

    expect(response.body).to include("buyer@example.com")
  end

  it "shows whether a customer is an admin" do
    create(:user, email_address: "admin@example.com", admin: true)
    customer = create(:user, email_address: "buyer@example.com", admin: false)
    sign_in_as("admin@example.com")

    get admin_customer_path(customer)

    expect(response.body).to include("buyer@example.com")
    expect(response.body).to include("Customer")
  end

  it "promotes a customer to admin" do
    create(:user, email_address: "admin@example.com", admin: true)
    customer = create(:user, email_address: "buyer@example.com", admin: false)
    sign_in_as("admin@example.com")

    patch admin_customer_path(customer), params: { user: { admin: true } }

    sign_in_as("buyer@example.com")
    get admin_customers_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Customers")
  end

  it "demotes an admin to a customer" do
    create(:user, email_address: "admin@example.com", admin: true)
    other = create(:user, email_address: "staff@example.com", admin: true)
    sign_in_as("admin@example.com")

    patch admin_customer_path(other), params: { user: { admin: false } }

    sign_in_as("staff@example.com")
    get admin_customers_path

    expect(response).to have_http_status(:forbidden)
  end

  it "blocks demoting the last admin" do
    admin = create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")

    patch admin_customer_path(admin), params: { user: { admin: false } }
    follow_redirect!

    expect(response.body).to include("The last admin cannot be demoted")
    expect(response.body).to include("Admin")
  end

  it "shows a customer's carts and orders" do
    create(:user, email_address: "admin@example.com", admin: true)
    customer = create(:user, email_address: "buyer@example.com", admin: false)
    sign_in_as("admin@example.com")
    cart = Cart.create!(user: customer)
    order = Order.create!(user: customer)

    get admin_customer_path(customer)

    expect(response.body).to include("Cart #{cart.id}")
    expect(response.body).to include("Order #{order.id}")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

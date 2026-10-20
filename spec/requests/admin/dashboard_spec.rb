require "rails_helper"

RSpec.describe "Admin dashboard" do
  it "shows marketplace totals to an admin" do
    create(:user, email_address: "admin@example.com", admin: true)
    Product.create!(title: "Linen shirt")
    sign_in_as("admin@example.com")

    get admin_root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Dashboard")
    expect(response.body).to include("Linen shirt")
  end

  it "refuses a signed-in customer" do
    create(:user, email_address: "buyer@example.com", admin: false)
    sign_in_as("buyer@example.com")

    get admin_root_path

    expect(response).to have_http_status(:forbidden)
    expect(response.body).to include("Admin access required")
  end

  it "sends a guest to sign in" do
    get admin_root_path

    expect(response).to redirect_to(new_session_path)
  end

  it "links totals, low stock, and captured payments into the console" do
    create(:user, email_address: "admin@example.com", admin: true)
    product = Product.create!(title: "Ceramic mug")
    variant = ProductVariant.create!(product: product, title: "Blue", inventory_quantity: 2)
    PaymentCollection.create!(amount: 10, captured_amount: 10, currency_code: "USD", status: "captured")
    sign_in_as("admin@example.com")

    get admin_root_path

    expect(response.body).to include(%(href="#{admin_products_path}"))
    expect(response.body).to include(%(href="#{admin_orders_path}"))
    expect(response.body).to include(%(href="#{admin_customers_path}"))
    expect(response.body).to include(%(href="#{admin_carts_path}"))
    expect(response.body).to include(%(href="#{admin_promotions_path}"))
    expect(response.body).to include(%(href="#{admin_fulfillments_path}"))
    expect(response.body).to include(%(href="#{admin_payments_path}"))
    expect(response.body).to include(%(href="#{admin_product_path(product)}#variant-#{variant.id}"))
    expect(response.body).to include("Dashboard")
    expect(response.body).to include("USD 10.00")
    unfinished = Product.create!(title: "Unfinished listing")
    get admin_root_path
    expect(response.body).to include(%(href="#{admin_product_path(unfinished)}"))
  end

  it "draws inspectable bars for totals, captured money, and payment status" do
    create(:user, email_address: "admin@example.com", admin: true)
    Product.create!(title: "Linen shirt")
    PaymentCollection.create!(amount: 40, captured_amount: 40, currency_code: "USD", status: "captured")
    PaymentCollection.create!(amount: 10, captured_amount: 0, currency_code: "EUR", status: "pending")
    sign_in_as("admin@example.com")

    get admin_root_path

    expect(response.body).to include('data-chart="totals"')
    expect(response.body).to include('data-label="Products" data-value="1"')
    expect(response.body).to include('data-chart="captured"')
    expect(response.body).to include('data-label="USD" data-value="40.00"')
    expect(response.body).to include('data-chart="payment-status"')
    expect(response.body).to include('data-label="Captured" data-value="1"')
    expect(response.body).to include('class="chart-bar ')
    expect(response.body).to include('style="width: 100%"')
  end

  it "sends the root path to the admin dashboard" do
    get root_path

    expect(response).to redirect_to("/admin")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

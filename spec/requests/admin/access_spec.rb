require "rails_helper"

RSpec.describe "Admin page access" do
  pages = {
    "products" => :admin_products_path,
    "customers" => :admin_customers_path,
    "orders" => :admin_orders_path,
    "fulfillments" => :admin_fulfillments_path,
    "payments" => :admin_payments_path,
    "promotions" => :admin_promotions_path,
    "carts" => :admin_carts_path
  }

  pages.each do |name, helper|
    it "refuses a customer on #{name}" do
      create(:user, email_address: "buyer@example.com", admin: false)
      sign_in_as("buyer@example.com")

      get public_send(helper)

      expect(response).to have_http_status(:forbidden)
    end

    it "sends a guest to sign in from #{name}" do
      get public_send(helper)

      expect(response).to redirect_to(new_session_path)
    end
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

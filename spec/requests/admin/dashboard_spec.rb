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

  it "sends the root path to the admin dashboard" do
    get root_path

    expect(response).to redirect_to("/admin")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

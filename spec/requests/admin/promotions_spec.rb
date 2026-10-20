require "rails_helper"

RSpec.describe "Admin promotions" do
  it "creates a promotion with a code and a decimal value" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")

    post admin_promotions_path, params: { promotion: { code: "WELCOME", value: "5.00" } }
    follow_redirect!

    expect(response.body).to include("WELCOME")
    expect(response.body).to include("5.00")
  end

  it "edits a promotion code and value" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    promotion = Promotion.create!(code: "WELCOME", value: 5)

    patch admin_promotion_path(promotion), params: { promotion: { code: "SPRING", value: "8.00" } }
    follow_redirect!

    expect(response.body).to include("SPRING")
    expect(response.body).to include("8.00")
  end

  it "removes a promotion" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    promotion = Promotion.create!(code: "WELCOME", value: 5)

    delete admin_promotion_path(promotion)
    follow_redirect!

    expect(response.body).not_to include("WELCOME")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

require "rails_helper"

RSpec.describe "Admin payments" do
  it "shows payment amounts, currency, and status" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    payment = PaymentCollection.create!(
      amount: 42.5,
      authorized_amount: 42.5,
      captured_amount: 40,
      refunded_amount: 2,
      currency_code: "USD",
      status: "captured"
    )

    get admin_payment_path(payment)

    expect(response.body).to include("USD 42.50")
    expect(response.body).to include("USD 40.00")
    expect(response.body).to include("USD 2.00")
    expect(response.body).to include("Captured")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

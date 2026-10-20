require "rails_helper"

RSpec.describe "Admin fulfillments" do
  it "lists an awaiting fulfillment that has no tracking" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    get admin_fulfillments_path

    expect(response.body).to include("Fulfillment #{fulfillment.id}")
    expect(response.body).to include("Awaiting shipment")
  end

  it "marks a fulfillment packed" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    patch admin_fulfillment_path(fulfillment), params: { status: "packed" }
    follow_redirect!

    expect(response.body).to include("Packed")
  end

  it "marks a fulfillment shipped with tracking" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    patch admin_fulfillment_path(fulfillment), params: { status: "shipped", tracking_number: "1Z999" }
    follow_redirect!

    expect(response.body).to include("Shipped")
    expect(response.body).to include("1Z999")
  end

  it "blocks marking shipped with no tracking" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    patch admin_fulfillment_path(fulfillment), params: { status: "shipped" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Tracking is required to mark shipped")
    expect(response.body).to include("Awaiting shipment")
  end

  it "marks a fulfillment delivered" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    patch admin_fulfillment_path(fulfillment), params: { status: "delivered" }
    follow_redirect!

    expect(response.body).to include("Delivered")
  end

  it "drops a cancelled fulfillment from awaiting shipment" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    fulfillment = Fulfillment.create!

    patch admin_fulfillment_path(fulfillment), params: { status: "cancelled" }
    get admin_fulfillments_path

    expect(response.body).not_to include("Fulfillment #{fulfillment.id}")
  end

  it "shows the lines and quantities in a fulfillment" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    cart = Cart.create!
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    fulfillment = Fulfillment.create!
    fulfillment.fulfillment_items.create!(line_item: cart.line_items.sole, quantity: 2)

    get admin_fulfillment_path(fulfillment)

    expect(response.body).to include("Mug")
    expect(response.body).to include("Qty 2")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

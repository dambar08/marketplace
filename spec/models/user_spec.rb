require "rails_helper"

RSpec.describe User do
  it "builds a staff account through FactoryBot" do
    user = create(:user, email_address: "staff@example.com")

    expect(user).to be_persisted
    expect(user.email_address).to eq("staff@example.com")
    expect(user.authenticate("password")).to eq(user)
  end
end

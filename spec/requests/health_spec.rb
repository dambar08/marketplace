require "rails_helper"

RSpec.describe "health check" do
  it "responds that the app is up" do
    get "/up"

    expect(response).to have_http_status(:ok)
  end
end

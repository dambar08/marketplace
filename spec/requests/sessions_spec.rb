require "rails_helper"

RSpec.describe "Sign in" do
  it "renders the staff form" do
    get new_session_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Sign in")
    expect(response.body).to include('name="email_address"')
    expect(response.body).to include('name="password"')
    expect(response.body).to include(new_password_path)
  end

  it "keeps the email after a failed sign-in" do
    post session_path, params: { email_address: "missing@example.com", password: "wrong" }

    expect(response).to redirect_to(new_session_path(email_address: "missing@example.com"))
    follow_redirect!
    expect(response.body).to include('value="missing@example.com"')
  end
end

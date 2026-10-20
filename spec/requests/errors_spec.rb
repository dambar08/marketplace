require "rails_helper"

RSpec.describe "production error pages" do
  around do |example|
    env = Rails.application.env_config
    show = env["action_dispatch.show_exceptions"]
    detailed = env["action_dispatch.show_detailed_exceptions"]
    env["action_dispatch.show_exceptions"] = :all
    env["action_dispatch.show_detailed_exceptions"] = false
    example.run
  ensure
    env["action_dispatch.show_exceptions"] = show
    env["action_dispatch.show_detailed_exceptions"] = detailed
  end

  it "shows the static page for a missing address" do
    get "/missing-page"

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("This page is not in the catalog.")
    expect(response.body).not_to include("ActionController")
  end

  it "shows the static page when a change is rejected" do
    with_forgery_protection do
      post session_path, params: { email_address: "staff@example.com", password: "password" }
    end

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("That change was not saved.")
    expect(response.body).not_to include("InvalidAuthenticityToken")
  end

  it "hides an unexpected failure" do
    allow_any_instance_of(SessionsController).to receive(:new).and_raise(RuntimeError, "secret boom")

    get new_session_path

    expect(response).to have_http_status(:internal_server_error)
    expect(response.body).to include("Something went wrong on our side.")
    expect(response.body).not_to include("secret boom")
  end

  def with_forgery_protection
    previous = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = previous
  end
end

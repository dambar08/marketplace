require "rails_helper"

RSpec.describe "cross-origin access" do
  let(:allowed_origin) { "https://shop.example" }

  around do |example|
    previous = ENV["CORS_ORIGIN"]
    if cors_origin.nil?
      ENV.delete("CORS_ORIGIN")
    else
      ENV["CORS_ORIGIN"] = cors_origin
    end
    example.run
  ensure
    if previous.nil?
      ENV.delete("CORS_ORIGIN")
    else
      ENV["CORS_ORIGIN"] = previous
    end
  end

  context "when the origin matches CORS_ORIGIN" do
    let(:cors_origin) { allowed_origin }

    it "names that origin on the health check" do
      get "/up", headers: { "Origin" => allowed_origin }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Access-Control-Allow-Origin"]).to eq(allowed_origin)
      expect(response.headers["Access-Control-Allow-Credentials"]).to be_blank
    end

    it "answers a preflight for a normal fetch" do
      options "/up", headers: {
        "Origin" => allowed_origin,
        "Access-Control-Request-Method" => "POST",
        "Access-Control-Request-Headers" => "Content-Type"
      }

      expect(response).to have_http_status(:success)
      expect(response.headers["Access-Control-Allow-Origin"]).to eq(allowed_origin)
      expect(response.headers["Access-Control-Allow-Methods"]).to include("POST")
      expect(response.headers["Access-Control-Allow-Headers"]).to match(/Content-Type/i)
      expect(response.headers["Access-Control-Allow-Credentials"]).to be_blank
    end
  end

  context "when the origin is not allowed" do
    let(:cors_origin) { allowed_origin }

    it "does not name a different origin" do
      get "/up", headers: { "Origin" => "https://shop.example:444" }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Access-Control-Allow-Origin"]).to be_blank
    end

    it "does not accept the same host on the wrong scheme" do
      get "/up", headers: { "Origin" => "http://shop.example" }

      expect(response.headers["Access-Control-Allow-Origin"]).to be_blank
    end
  end

  context "when CORS_ORIGIN is missing" do
    let(:cors_origin) { nil }

    it "allows no origin" do
      get "/up", headers: { "Origin" => allowed_origin }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Access-Control-Allow-Origin"]).to be_blank
    end
  end

  context "when CORS_ORIGIN is blank" do
    let(:cors_origin) { "" }

    it "allows no origin" do
      get "/up", headers: { "Origin" => allowed_origin }

      expect(response.headers["Access-Control-Allow-Origin"]).to be_blank
    end
  end

  context "when the request has no Origin" do
    let(:cors_origin) { allowed_origin }

    it "leaves the health check unchanged" do
      get "/up"

      expect(response).to have_http_status(:ok)
      expect(response.headers["Access-Control-Allow-Origin"]).to be_blank
    end
  end
end

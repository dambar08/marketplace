Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins do |source, _env|
      allowed = ENV["CORS_ORIGIN"].to_s
      allowed.present? && source == allowed
    end

    resource "*",
      headers: %w[Content-Type Accept],
      methods: %i[get post put patch delete options],
      credentials: false
  end
end

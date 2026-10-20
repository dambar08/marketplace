require "rails_helper"

RSpec.describe "Admin products" do
  it "creates a product with a title" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")

    get new_admin_product_path
    expect(response).to have_http_status(:ok)

    post admin_products_path, params: { product: { title: "Linen shirt" } }
    follow_redirect!

    expect(response.body).to include("Linen shirt")
    expect(response.body).not_to include("Slug")
  end

  it "edits a product title, subtitle, and description" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")

    patch admin_product_path(product), params: {
      product: { title: "Wool coat", subtitle: "Heavy", description: "Winter weight" }
    }
    follow_redirect!

    expect(response.body).to include("Wool coat")
    expect(response.body).to include("Heavy")
    expect(response.body).to include("Winter weight")
    expect(response.body).to include("wool-coat")
  end

  it "attaches a thumbnail" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/thumbnail.png"), "image/png")

    patch admin_product_path(product), params: { product: { title: product.title, thumbnail: file } }
    follow_redirect!

    expect(response.body).to include("Thumbnail")
    expect(response.body).to include("thumbnail.png")
  end

  it "replaces a thumbnail" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    product.thumbnail.attach(io: Rails.root.join("spec/fixtures/files/thumbnail.png").open, filename: "thumbnail.png", content_type: "image/png")
    file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/replacement.png"), "image/png")

    patch admin_product_path(product), params: { product: { title: product.title, thumbnail: file } }
    follow_redirect!

    expect(response.body).to include("replacement.png")
    expect(response.body).not_to include("thumbnail.png")
  end

  it "removes a thumbnail" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    product.thumbnail.attach(io: Rails.root.join("spec/fixtures/files/thumbnail.png").open, filename: "thumbnail.png", content_type: "image/png")

    delete admin_product_thumbnail_path(product)
    follow_redirect!

    expect(response.body).not_to include("thumbnail.png")
    expect(response.body).to include("Linen shirt")
  end

  it "adds an option with a title and values" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")

    post admin_product_options_path(product), params: { product_option: { title: "Color", values: "Blue, Green" } }
    follow_redirect!

    expect(response.body).to include("Color")
    expect(response.body).to include("Blue")
    expect(response.body).to include("Green")
  end

  it "edits an option title and values" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    option = product.options.create!(title: "Color", values: [ "Blue" ])

    patch admin_product_option_path(product, option), params: { product_option: { title: "Size", values: "Small, Medium" } }
    follow_redirect!

    expect(response.body).to include("Size")
    expect(response.body).to include("Small")
    expect(response.body).to include("Medium")
    expect(response.body).not_to include("Color")
  end

  it "removes an option" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    option = product.options.create!(title: "Color", values: [ "Blue" ])

    delete admin_product_option_path(product, option)
    follow_redirect!

    expect(response.body).not_to include("Color")
  end

  it "keeps a variant's chosen value when an option is renamed" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    option = product.options.create!(title: "Color", values: [ "Blue", "Green" ])
    product.variants.create!(title: "Sea", sku: "LINEN-SEA", options: { "Color" => "Green" })

    patch admin_product_option_path(product, option), params: { product_option: { title: "Colour", values: "Blue, Green" } }
    follow_redirect!

    expect(response.body).to include("Colour: Green")
    expect(response.body).not_to include("Color: Green")
  end

  it "adds a variant with a title and SKU" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")

    post admin_product_variants_path(product), params: { product_variant: { title: "Blue", sku: "LINEN-BLU" } }
    follow_redirect!

    expect(response.body).to include("Blue")
    expect(response.body).to include("LINEN-BLU")
  end

  it "records the option values a variant is" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    product.options.create!(title: "Color", values: [ "Blue", "Green" ])

    post admin_product_variants_path(product), params: {
      product_variant: { title: "Sea", sku: "LINEN-SEA", chosen_values: { "Color" => "Green" } }
    }
    follow_redirect!

    expect(response.body).to include("Color: Green")
    expect(response.body).not_to include("Color: Blue")
  end

  it "edits a variant title, SKU, and chosen values" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    product.options.create!(title: "Color", values: [ "Blue", "Green" ])
    variant = product.variants.create!(title: "Sea", sku: "LINEN-SEA", options: { "Color" => "Green" })

    patch admin_product_variant_path(product, variant), params: {
      product_variant: { title: "Forest", sku: "LINEN-FOR", chosen_values: { "Color" => "Blue" } }
    }
    follow_redirect!

    expect(response.body).to include("Forest")
    expect(response.body).to include("LINEN-FOR")
    expect(response.body).to include("Color: Blue")
    expect(response.body).not_to include("Color: Green")
  end

  it "sets variant stock and backorder" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU", inventory_quantity: 1, allow_backorder: false)

    patch admin_product_variant_path(product, variant), params: {
      product_variant: { title: "Blue", sku: "LINEN-BLU", inventory_quantity: 4, allow_backorder: "1" }
    }
    follow_redirect!

    expect(response.body).to include("Stock 4")
    expect(response.body).to include("Backorder allowed")

    patch admin_product_variant_path(product, variant), params: {
      product_variant: { title: "Blue", sku: "LINEN-BLU", inventory_quantity: 4, allow_backorder: "0" }
    }
    follow_redirect!

    expect(response.body).to include("Backorder disallowed")
  end

  it "sets a variant price as an amount and currency" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU")

    post admin_product_variant_prices_path(product, variant), params: {
      product_variant_price: { amount: "19.99", currency: "USD" }
    }
    follow_redirect!

    expect(response.body).to include("USD 19.99")
  end

  it "keeps a second currency as a separate price" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU")
    variant.prices.create!(amount: "19.99", currency: "USD")

    post admin_product_variant_prices_path(product, variant), params: {
      product_variant_price: { amount: "15.50", currency: "EUR" }
    }
    follow_redirect!

    expect(response.body).to include("USD 19.99")
    expect(response.body).to include("EUR 15.50")
  end

  it "edits a variant price" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU")
    price = variant.prices.create!(amount: "19.99", currency: "USD")

    patch admin_product_variant_price_path(product, variant, price), params: {
      product_variant_price: { amount: "21.00", currency: "USD" }
    }
    follow_redirect!

    expect(response.body).to include("USD 21.00")
    expect(response.body).not_to include("USD 19.99")
  end

  it "removes a variant price" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU")
    price = variant.prices.create!(amount: "19.99", currency: "USD")

    delete admin_product_variant_price_path(product, variant, price)
    follow_redirect!

    expect(response.body).not_to include("USD 19.99")
  end

  it "removes a variant" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    product = Product.create!(title: "Linen shirt")
    variant = product.variants.create!(title: "Blue", sku: "LINEN-BLU")

    delete admin_product_variant_path(product, variant)
    follow_redirect!

    expect(response.body).to include("No variants")
    expect(response.body).not_to include("LINEN-BLU")
  end

  it "lists products that have no variants" do
    create(:user, email_address: "admin@example.com", admin: true)
    sign_in_as("admin@example.com")
    Product.create!(title: "Unfinished listing")

    get admin_products_path

    expect(response.body).to include("Unfinished listing")
    expect(response.body).to include("No variants")
  end

  def sign_in_as(email)
    post session_path, params: { email_address: email, password: "password" }
  end
end

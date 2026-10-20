# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_20_045804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_1", null: false
    t.string "address_2"
    t.string "city", null: false
    t.string "company"
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "postal_code", null: false
    t.string "province"
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "original_item_subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "original_item_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at"
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "fulfillment_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "line_item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["line_item_id"], name: "index_fulfillment_items_on_line_item_id"
  end

  create_table "fulfillment_labels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "fulfillment_id", null: false
    t.string "label_url"
    t.string "tracking_number", null: false
    t.string "tracking_url", null: false
    t.datetime "updated_at", null: false
    t.index ["fulfillment_id"], name: "index_fulfillment_labels_on_fulfillment_id"
  end

  create_table "fulfillments", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "delivered_at"
    t.datetime "packed_at"
    t.string "provider_id"
    t.datetime "shipped_at"
    t.string "tracking_links", default: [], array: true
    t.string "tracking_numbers", default: [], array: true
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_variant_id"
    t.integer "quantity", default: 1, null: false
    t.string "subtitle"
    t.string "title", null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["product_variant_id"], name: "index_line_items_on_product_variant_id"
  end

  create_table "metadata", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["key"], name: "index_metadata_on_key", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_collections", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "authorized_amount", precision: 10, scale: 2
    t.decimal "captured_amount", precision: 10, scale: 2
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "currency_code", null: false
    t.decimal "refunded_amount", precision: 10, scale: 2
    t.string "status", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "values", default: [], null: false, array: true
    t.index ["product_id"], name: "index_product_options_on_product_id"
  end

  create_table "product_variant_prices", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "product_variant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_variant_id"], name: "index_product_variant_prices_on_product_variant_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.boolean "allow_backorder"
    t.datetime "created_at", null: false
    t.integer "inventory_quantity"
    t.jsonb "options", default: {}, null: false
    t.bigint "product_id", null: false
    t.string "sku"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.jsonb "metadata", default: {}, null: false
    t.string "slug", null: false
    t.string "subtitle"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "promotions", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, default: "0.0", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.decimal "tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_option_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "label", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_options", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "shipping_option_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_option_type_id"], name: "index_shipping_options_on_shipping_option_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "shipping_options", "shipping_option_types"
end

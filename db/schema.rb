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

ActiveRecord::Schema[8.1].define(version: 2026_03_15_005001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "assistant_files", force: :cascade do |t|
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.string "file_name"
    t.string "resource_name"
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_assistant_files_on_assistant_id"
  end

  create_table "assistant_tools", force: :cascade do |t|
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.bigint "tool_id", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_assistant_tools_on_assistant_id"
    t.index ["tool_id"], name: "index_assistant_tools_on_tool_id"
  end

  create_table "assistants", force: :cascade do |t|
    t.string "assistant_id", null: false
    t.bigint "company_id", null: false
    t.text "conditions"
    t.text "context"
    t.datetime "created_at", null: false
    t.text "instructions", null: false
    t.text "model"
    t.string "name", null: false
    t.text "outputs"
    t.text "reasoning"
    t.text "role"
    t.text "scrapping_instructions"
    t.string "slug"
    t.text "task"
    t.float "temperature", default: 1.0
    t.float "top_p", default: 1.0
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_assistants_on_company_id"
    t.index ["slug"], name: "index_assistants_on_slug", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "parent_id"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["company_id", "slug"], name: "index_categories_on_company_id_and_slug", unique: true
    t.index ["company_id"], name: "index_categories_on_company_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_products_on_category_id"
    t.index ["product_id"], name: "index_category_products_on_product_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "ai_source", default: "openai"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "company_item_configurations", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["company_id", "name"], name: "index_company_item_configurations_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_company_item_configurations_on_company_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "assistant_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "current_run_id"
    t.bigint "lead_id", null: false
    t.jsonb "meta_data"
    t.string "thread_id"
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_conversations_on_assistant_id"
    t.index ["company_id"], name: "index_conversations_on_company_id"
    t.index ["lead_id"], name: "index_conversations_on_lead_id"
  end

  create_table "item_configurations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.jsonb "options"
    t.datetime "updated_at", null: false
  end

  create_table "lead_companies", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.bigint "lead_id", null: false
    t.text "summary"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_lead_companies_on_company_id"
    t.index ["lead_id"], name: "index_lead_companies_on_lead_id"
  end

  create_table "leads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.jsonb "extra_data"
    t.string "name"
    t.string "phone"
    t.text "preferences"
    t.datetime "updated_at", null: false
  end

  create_table "line_item_dates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "quote_id", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "quote_id"], name: "index_line_item_dates_on_date_and_quote_id", unique: true
    t.index ["date"], name: "index_line_item_dates_on_date"
    t.index ["quote_id"], name: "index_line_item_dates_on_quote_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "meta_data"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "option_types", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.boolean "filterable", default: false, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_option_types_on_company_id"
  end

  create_table "option_values", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "label"
    t.string "name"
    t.bigint "option_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_option_values_on_company_id"
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "product_option_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_type_id", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_product_option_types_on_option_type_id"
    t.index ["product_id"], name: "index_product_option_types_on_product_id"
  end

  create_table "product_option_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_value_id", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["option_value_id"], name: "index_product_option_values_on_option_value_id"
    t.index ["product_id", "option_value_id"], name: "index_product_option_values_on_product_id_and_option_value_id", unique: true
    t.index ["product_id"], name: "index_product_option_values_on_product_id"
  end

# Could not dump table "products" because of following StandardError
#   Unknown type 'vector' for column 'embedding'


  create_table "quotes", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tools", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", default: ""
    t.jsonb "function", default: {}
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_option_values", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.bigint "option_value_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["company_id"], name: "index_variant_option_values_on_company_id"
    t.index ["option_value_id"], name: "index_variant_option_values_on_option_value_id"
    t.index ["variant_id"], name: "index_variant_option_values_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_master", default: false, null: false
    t.float "price"
    t.bigint "product_id", null: false
    t.string "sku"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_variants_on_company_id"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object", default: {}, null: false
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assistant_files", "assistants"
  add_foreign_key "assistant_tools", "assistants"
  add_foreign_key "assistant_tools", "tools"
  add_foreign_key "assistants", "companies"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "categories", "companies"
  add_foreign_key "category_products", "categories"
  add_foreign_key "category_products", "products"
  add_foreign_key "company_item_configurations", "companies"
  add_foreign_key "conversations", "assistants"
  add_foreign_key "conversations", "companies"
  add_foreign_key "conversations", "leads"
  add_foreign_key "lead_companies", "companies"
  add_foreign_key "lead_companies", "leads"
  add_foreign_key "line_item_dates", "quotes"
  add_foreign_key "messages", "conversations"
  add_foreign_key "option_types", "companies"
  add_foreign_key "option_values", "companies"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "product_option_types", "option_types"
  add_foreign_key "product_option_types", "products"
  add_foreign_key "product_option_values", "option_values"
  add_foreign_key "product_option_values", "products"
  add_foreign_key "products", "companies"
  add_foreign_key "quotes", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "variant_option_values", "companies"
  add_foreign_key "variant_option_values", "option_values"
  add_foreign_key "variant_option_values", "variants"
  add_foreign_key "variants", "companies"
  add_foreign_key "variants", "products"
end

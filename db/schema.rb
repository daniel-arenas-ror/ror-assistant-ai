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

ActiveRecord::Schema[8.1].define(version: 2025_11_11_213742) do
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

  create_table "assistants", force: :cascade do |t|
    t.string "assistant_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.text "instructions", null: false
    t.text "model"
    t.string "name", null: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_assistants_on_company_id"
    t.index ["slug"], name: "index_assistants_on_slug", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "ai_source", default: "openai"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.string "current_run_id"
    t.bigint "lead_id", null: false
    t.jsonb "meta_data"
    t.string "thread_id"
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_conversations_on_assistant_id"
    t.index ["lead_id"], name: "index_conversations_on_lead_id"
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

  create_table "quotes", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "real_estates" because of following StandardError
#   Unknown type 'vector' for column 'embedding'


  create_table "recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
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

  add_foreign_key "assistants", "companies"
  add_foreign_key "conversations", "assistants"
  add_foreign_key "conversations", "leads"
  add_foreign_key "lead_companies", "companies"
  add_foreign_key "lead_companies", "leads"
  add_foreign_key "line_item_dates", "quotes"
  add_foreign_key "messages", "conversations"
  add_foreign_key "quotes", "companies"
  add_foreign_key "real_estates", "companies"
  add_foreign_key "users", "companies"
end

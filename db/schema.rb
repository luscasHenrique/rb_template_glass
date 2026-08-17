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

ActiveRecord::Schema[8.1].define(version: 2026_08_17_142836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "addressable_id", null: false
    t.string "addressable_type", null: false
    t.string "city"
    t.string "complement"
    t.datetime "created_at", null: false
    t.string "number"
    t.string "state"
    t.string "street"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "policy_terms", force: :cascade do |t|
    t.boolean "active"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "avatar_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "tracking_integrations", force: :cascade do |t|
    t.string "account_id"
    t.datetime "created_at", null: false
    t.boolean "is_active"
    t.string "provider_name"
    t.datetime "updated_at", null: false
  end

  create_table "user_agreements", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.bigint "policy_term_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["policy_term_id"], name: "index_user_agreements_on_policy_term_id"
    t.index ["user_id"], name: "index_user_agreements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "user_agreements", "policy_terms"
  add_foreign_key "user_agreements", "users"
end

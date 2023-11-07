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

ActiveRecord::Schema[7.1].define(version: 2023_11_07_023126) do
  create_table "addresses", force: :cascade do |t|
    t.string "street_name"
    t.string "street_number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.integer "guesthouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guesthouse_id"], name: "index_addresses_on_guesthouse_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "phone"
    t.string "email"
    t.integer "guesthouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guesthouse_id"], name: "index_contacts_on_guesthouse_id"
  end

  create_table "guesthouses", force: :cascade do |t|
    t.string "corporate_name"
    t.string "trading_name"
    t.string "registration_number"
    t.text "description"
    t.boolean "allow_pets"
    t.text "usage_policy"
    t.time "check_in"
    t.time "check_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_methods"
    t.integer "owner_id", null: false
    t.integer "status", default: 0
    t.index ["owner_id"], name: "index_guesthouses_on_owner_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "area"
    t.integer "max_capacity"
    t.decimal "daily_rate", precision: 8, scale: 2
    t.boolean "has_bathroom"
    t.boolean "has_balcony"
    t.boolean "has_air_conditioner"
    t.boolean "has_tv"
    t.boolean "has_wardrobe"
    t.boolean "has_safe"
    t.boolean "is_accessible"
    t.integer "guesthouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["guesthouse_id"], name: "index_rooms_on_guesthouse_id"
  end

  create_table "seasonal_rates", force: :cascade do |t|
    t.date "start_date"
    t.date "finish_date"
    t.decimal "rate", precision: 8, scale: 2
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seasonal_rates_on_room_id"
  end

  add_foreign_key "addresses", "guesthouses"
  add_foreign_key "contacts", "guesthouses"
  add_foreign_key "guesthouses", "owners"
  add_foreign_key "rooms", "guesthouses"
  add_foreign_key "seasonal_rates", "rooms"
end

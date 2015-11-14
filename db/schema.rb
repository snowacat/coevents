# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150207151158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "login"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "email"
  end

  add_index "admins", ["auth_token"], name: "index_admins_on_auth_token", using: :btree

  create_table "categories", force: true do |t|
    t.string  "title",  null: false
    t.integer "parent"
  end

  add_index "categories", ["id"], name: "index_categories_on_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title",                          null: false
    t.string   "content",                        null: false
    t.integer  "category_id"
    t.boolean  "paid",           default: false, null: false
    t.decimal  "payment_amount"
    t.datetime "start_date",                     null: false
    t.datetime "end_date",                       null: false
    t.float    "latitude",                       null: false
    t.float    "longitude",                      null: false
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "send_message",   default: false, null: false
  end

  create_table "user_events", force: true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "users", force: true do |t|
    t.string  "user_name",    limit: 64
    t.string  "email",        limit: 128
    t.string  "phone_number", limit: 20
    t.string  "nationality",  limit: 32
    t.boolean "verified",                 default: false, null: false
    t.string  "city",                     default: "",    null: false
    t.integer "gender",       limit: 2
    t.date    "birthdate"
  end

end

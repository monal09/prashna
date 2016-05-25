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

ActiveRecord::Schema.define(version: 20160523141629) do

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                      limit: 255,                 null: false
    t.string   "last_name",                       limit: 255,                 null: false
    t.string   "email",                           limit: 255,                 null: false
    t.string   "password_digest",                 limit: 255,                 null: false
    t.boolean  "admin",                                       default: false
    t.string   "verification_token",              limit: 255
    t.datetime "verification_token_expiry_at"
    t.datetime "verified_at"
    t.string   "forgot_password_token",           limit: 255
    t.datetime "forgot_password_token_expiry_at"
    t.string   "remember_me_token",               limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "users", ["forgot_password_token"], name: "index_users_on_forgot_password_token", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["verification_token"], name: "index_users_on_verification_token", using: :btree

end

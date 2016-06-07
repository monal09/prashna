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

ActiveRecord::Schema.define(version: 20160606120052) do

  create_table "answers", force: :cascade do |t|
    t.string   "content",     limit: 255
    t.integer  "user_id",     limit: 4
    t.integer  "question_id", limit: 4
    t.integer  "upvotes",     limit: 4,   default: 0
    t.integer  "downvotes",   limit: 4,   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "credit_transactions", force: :cascade do |t|
    t.float    "amount",        limit: 24,  null: false
    t.integer  "user_id",       limit: 4,   null: false
    t.integer  "event",         limit: 4
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "credit_transactions", ["user_id"], name: "index_credit_transactions_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title",         limit: 255,                   null: false
    t.text     "content",       limit: 65535,                 null: false
    t.string   "pdf_name",      limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "published",                   default: false
    t.string   "slug",          limit: 255
    t.integer  "answers_count", limit: 4
  end

  add_index "questions", ["title"], name: "index_questions_on_title", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "questions_topics", force: :cascade do |t|
    t.integer  "question_id", limit: 4, null: false
    t.integer  "topic_id",    limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "questions_topics", ["question_id"], name: "index_questions_topics_on_question_id", using: :btree
  add_index "questions_topics", ["topic_id"], name: "index_questions_topics_on_topic_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "topics", ["name"], name: "index_topics_on_name", using: :btree

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
    t.float    "credit_balance",                  limit: 24,  default: 0.0,   null: false
    t.integer  "lock_version",                    limit: 4
  end

  add_index "users", ["forgot_password_token"], name: "index_users_on_forgot_password_token", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["verification_token"], name: "index_users_on_verification_token", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id",   limit: 4
    t.string   "votable_type", limit: 255
    t.boolean  "upvote",                   null: false
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree

end

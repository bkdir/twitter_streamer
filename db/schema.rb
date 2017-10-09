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

ActiveRecord::Schema.define(version: 20171009023331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "media", force: :cascade do |t|
    t.bigint   "tweet_id",   null: false
    t.string   "media_url",  null: false
    t.string   "media_type"
    t.datetime "created_at"
    t.index ["tweet_id", "media_type"], name: "index_media_on_tweet_id_and_media_type", using: :btree
    t.index ["tweet_id"], name: "index_media_on_tweet_id", using: :btree
  end

  create_table "tweets", primary_key: "tweet_id", id: :bigint, force: :cascade do |t|
    t.bigint   "user_id",                     null: false
    t.text     "text"
    t.text     "quoted_text"
    t.bigint   "rt_id"
    t.boolean  "deleted",     default: false
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.string   "type"
    t.index ["user_id", "deleted"], name: "index_tweets_on_user_id_and_deleted", using: :btree
  end

  create_table "twitter_users", primary_key: "user_id", id: :bigint, force: :cascade do |t|
    t.string   "screen_name"
    t.string   "name"
    t.integer  "deleted_tweets_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["screen_name"], name: "index_twitter_users_on_screen_name", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "last_login"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "media", "tweets", primary_key: "tweet_id"
  add_foreign_key "tweets", "twitter_users", column: "user_id", primary_key: "user_id"
end

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

ActiveRecord::Schema.define(version: 20170104035144) do

  create_table "media", force: :cascade do |t|
    t.string   "media_id",   null: false
    t.string   "tweet_id",   null: false
    t.boolean  "rt_media"
    t.string   "media_url",  null: false
    t.string   "media_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id", "tweet_id"], name: "index_media_on_media_id_and_tweet_id", unique: true
    t.index ["media_id"], name: "index_media_on_media_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "user_id",     null: false
    t.string   "tweet_id",    null: false
    t.string   "screen_name"
    t.string   "name"
    t.text     "text",        null: false
    t.string   "rt_id"
    t.text     "quoted_text"
    t.boolean  "deleted"
    t.datetime "tweeted_at"
    t.datetime "deleted_at"
    t.index ["deleted"], name: "index_tweets_on_deleted"
    t.index ["tweet_id"], name: "index_tweets_on_tweet_id", unique: true
    t.index ["user_id", "deleted"], name: "index_tweets_on_user_id_and_deleted"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end

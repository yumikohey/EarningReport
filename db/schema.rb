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

ActiveRecord::Schema.define(version: 20150717061514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beta_quotes", force: :cascade do |t|
    t.string   "stock"
    t.date     "date"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.integer  "volume"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "five_avg"
    t.float    "ten_avg"
    t.integer  "cross"
  end

  add_index "beta_quotes", ["date"], name: "index_beta_quotes_on_date", using: :btree
  add_index "beta_quotes", ["stock_id"], name: "index_beta_quotes_on_stock_id", using: :btree

  create_table "daily_options", force: :cascade do |t|
    t.string   "symbol"
    t.integer  "stock_id"
    t.date     "expiration_date"
    t.string   "option_chains"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "record_date"
  end

  add_index "daily_options", ["symbol"], name: "index_daily_options_on_symbol", using: :btree

  create_table "earning_calendars", force: :cascade do |t|
    t.string   "company_name"
    t.string   "symbol"
    t.integer  "stock_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "time"
    t.date     "day"
    t.string   "eps"
  end

  create_table "ereports", force: :cascade do |t|
    t.string   "symbol"
    t.date     "date"
    t.boolean  "before_or_after_hour"
    t.integer  "stock_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "ereports", ["date"], name: "index_ereports_on_date", using: :btree
  add_index "ereports", ["symbol"], name: "index_ereports_on_symbol", using: :btree

  create_table "history_quotes", force: :cascade do |t|
    t.string   "stock"
    t.date     "date"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.integer  "volume"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "five_avg"
    t.float    "ten_avg"
    t.integer  "cross"
  end

  add_index "history_quotes", ["date"], name: "index_history_quotes_on_date", using: :btree
  add_index "history_quotes", ["stock_id"], name: "index_history_quotes_on_stock_id", using: :btree

  create_table "option_chains", force: :cascade do |t|
    t.string   "symbol"
    t.integer  "stock_id"
    t.date     "expiration_date"
    t.string   "option_chains"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "price_after_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "price_after_ers", ["ereport_id"], name: "index_price_after_ers_on_ereport_id", using: :btree
  add_index "price_after_ers", ["price_date"], name: "index_price_after_ers_on_price_date", using: :btree

  create_table "price_before_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "price_before_ers", ["ereport_id"], name: "index_price_before_ers_on_ereport_id", using: :btree
  add_index "price_before_ers", ["price_date"], name: "index_price_before_ers_on_price_date", using: :btree

  create_table "price_on_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "price_on_ers", ["ereport_id"], name: "index_price_on_ers_on_ereport_id", using: :btree
  add_index "price_on_ers", ["price_date"], name: "index_price_on_ers_on_price_date", using: :btree

  create_table "put_call_ratios", force: :cascade do |t|
    t.date     "date"
    t.integer  "calls"
    t.integer  "puts"
    t.integer  "total"
    t.decimal  "pcratio"
    t.string   "symbol"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sma_averages", force: :cascade do |t|
    t.string   "stock"
    t.date     "date"
    t.float    "five_avg"
    t.float    "ten_avg"
    t.integer  "cross"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string   "symbol"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "stock_volume"
    t.string   "name"
    t.string   "lastsale"
    t.string   "market_cap"
    t.integer  "ipo_year"
    t.string   "sector"
    t.string   "industry"
    t.string   "summary_quote"
    t.date     "ipodate"
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end

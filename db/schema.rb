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

ActiveRecord::Schema.define(version: 20150508225359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "price_after_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_before_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_on_ers", force: :cascade do |t|
    t.date     "price_date"
    t.text     "quote"
    t.integer  "ereport_id"
    t.integer  "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string   "symbol"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "stock_volume"
  end

end

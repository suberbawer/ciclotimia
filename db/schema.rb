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

ActiveRecord::Schema.define(version: 20140303173755) do

  create_table "articles", force: true do |t|
    t.string   "description"
    t.string   "estimated_price"
    t.date     "entry_date"
    t.string   "commission_per"
    t.string   "commission_cash"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "input_id"
    t.integer  "provider_id"
    t.integer  "output_id"
    t.boolean  "sent",            default: false
  end

  create_table "caja_transactions", force: true do |t|
    t.integer  "caja_id"
    t.integer  "transaction_id"
    t.string   "transaction_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cajas", force: true do |t|
    t.decimal  "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "status"
    t.string   "start_Date"
    t.string   "datetime"
    t.datetime "end_date"
  end

  create_table "inputs", force: true do |t|
    t.integer  "caja_id"
    t.integer  "caja_transaction_id"
    t.string   "type"
    t.integer  "amount"
    t.integer  "cancel_id"
    t.string   "concept"
    t.string   "status",              default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comission_per"
    t.string   "comission_cash"
  end

  create_table "outputs", force: true do |t|
    t.integer  "caja_id"
    t.integer  "caja_transaction_id"
    t.string   "type"
    t.integer  "amount"
    t.integer  "cancel_id"
    t.string   "concept"
    t.string   "status",              default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "ci"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

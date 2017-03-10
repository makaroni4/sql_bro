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

ActiveRecord::Schema.define(version: 20170310080315) do

  create_table "db_connections", force: :cascade do |t|
    t.string   "adapter"
    t.string   "user"
    t.string   "password"
    t.string   "host"
    t.string   "encoding"
    t.integer  "timeout"
    t.string   "database"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "db_queries", force: :cascade do |t|
    t.text     "body"
    t.integer  "db_connection_id"
    t.text     "fields"
    t.text     "result"
    t.text     "description"
    t.float    "duration"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["db_connection_id"], name: "index_db_queries_on_db_connection_id"
  end

end
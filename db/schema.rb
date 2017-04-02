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

ActiveRecord::Schema.define(version: 20170402130929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "db_columns", force: :cascade do |t|
    t.integer  "db_table_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["db_table_id", "name"], name: "index_db_columns_on_db_table_id_and_name", unique: true, using: :btree
    t.index ["db_table_id"], name: "index_db_columns_on_db_table_id", using: :btree
  end

  create_table "db_connections", force: :cascade do |t|
    t.string   "adapter"
    t.string   "user"
    t.string   "password"
    t.string   "host"
    t.integer  "port"
    t.integer  "timeout"
    t.string   "database"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "db_queries", force: :cascade do |t|
    t.text     "body"
    t.integer  "db_connection_id"
    t.json     "fields"
    t.json     "result"
    t.text     "description"
    t.float    "duration"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "results_count"
    t.index ["db_connection_id"], name: "index_db_queries_on_db_connection_id", using: :btree
  end

  create_table "db_schemas", force: :cascade do |t|
    t.integer  "db_connection_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["db_connection_id", "name"], name: "index_db_schemas_on_db_connection_id_and_name", unique: true, using: :btree
    t.index ["db_connection_id"], name: "index_db_schemas_on_db_connection_id", using: :btree
  end

  create_table "db_tables", force: :cascade do |t|
    t.integer  "db_schema_id"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.bigint   "size"
    t.bigint   "rows_count"
    t.boolean  "is_view",      default: false
    t.index ["db_schema_id", "name"], name: "index_db_tables_on_db_schema_id_and_name", unique: true, using: :btree
    t.index ["db_schema_id"], name: "index_db_tables_on_db_schema_id", using: :btree
  end

  add_foreign_key "db_columns", "db_tables"
  add_foreign_key "db_queries", "db_connections"
  add_foreign_key "db_schemas", "db_connections"
  add_foreign_key "db_tables", "db_schemas"
end

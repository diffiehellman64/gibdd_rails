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

ActiveRecord::Schema.define(version: 20160815193831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "districts", force: :cascade do |t|
    t.integer  "code",       null: false
    t.string   "name",       null: false
    t.string   "short_name", null: false
    t.string   "alias_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "districts", ["code"], name: "index_districts_on_code", unique: true, using: :btree

  create_table "operative_records", force: :cascade do |t|
    t.integer  "user_id",                             default: 0, null: false
    t.integer  "district_id",                                     null: false
    t.date     "target_day",                                      null: false
    t.integer  "personal_count"
    t.integer  "reg_emergency_count"
    t.integer  "dead_count"
    t.integer  "perished_count"
    t.integer  "reg_emergency_child_count"
    t.integer  "dead_child_count"
    t.integer  "perished_child_count"
    t.integer  "reg_emergency_drunk_count"
    t.integer  "dead_drunk_count"
    t.integer  "perished_drunk_count"
    t.integer  "reg_emergency_footer_count"
    t.integer  "dead_footer_count"
    t.integer  "perished_footer_count"
    t.integer  "reg_emergency_footer_on_zebra_count"
    t.integer  "dead_footer_on_zebra_count"
    t.integer  "perished_footer_on_zebra_count"
    t.integer  "adm_emergency_count"
    t.integer  "all_violations_count"
    t.integer  "drunk_count"
    t.integer  "opposite_count"
    t.integer  "not_having_count"
    t.integer  "speed_count"
    t.integer  "failure_to_footer_count"
    t.integer  "belts_count"
    t.integer  "passengers_count"
    t.integer  "tinting_count"
    t.integer  "footer_count"
    t.integer  "arrested_day_count"
    t.integer  "arrested_all_count"
    t.integer  "parking_count"
    t.integer  "article_264_1_count"
    t.integer  "oop_count"
    t.integer  "not_trafic_oop_count"
    t.integer  "solved_crime_count"
    t.integer  "stealing_autos"
    t.integer  "theft_autos"
    t.integer  "stealing_solved"
    t.integer  "theft_solved"
    t.integer  "stealing_solved_gibdd"
    t.integer  "theft_solved_gibdd"
    t.string   "source"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "operative_records", ["district_id"], name: "index_operative_records_on_district_id", using: :btree
  add_index "operative_records", ["target_day"], name: "index_operative_records_on_target_day", using: :btree
  add_index "operative_records", ["user_id"], name: "index_operative_records_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "district_id"
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username"
    t.string   "fullname"
    t.string   "discription"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "operative_records", "users"
end

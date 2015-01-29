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

ActiveRecord::Schema.define(version: 20150128052915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tenants", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "host"
    t.text     "description"
    t.string   "analytics_id"
    t.string   "theme"
    t.string   "twitter_id"
    t.string   "facebook_id"
    t.string   "instagram_id"
    t.string   "foursquare_id"
    t.string   "google_plus_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenants_users", id: false, force: true do |t|
    t.integer "tenant_id"
    t.integer "user_id"
  end

  add_index "tenants_users", ["tenant_id"], name: "index_tenants_users_on_tenant_id", using: :btree
  add_index "tenants_users", ["user_id"], name: "index_tenants_users_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "title"
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mongo_id"
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

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

ActiveRecord::Schema.define(version: 20150211180336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "blocks", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "type"
    t.integer  "section_id"
    t.integer  "column"
    t.integer  "position"
    t.hstore   "options"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "show_standings"
    t.boolean  "show_players"
    t.boolean  "show_statistics"
    t.text     "standings_array", default: [], array: true
    t.integer  "tenant_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues_seasons", force: :cascade do |t|
    t.integer "league_id"
    t.integer "season_id"
  end

  add_index "leagues_seasons", ["league_id"], name: "index_leagues_seasons_on_league_id", using: :btree
  add_index "leagues_seasons", ["season_id"], name: "index_leagues_seasons_on_season_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "title"
    t.string   "slug"
    t.string   "url_path"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "link_url"
    t.boolean  "show_in_menu"
    t.string   "title_in_menu"
    t.boolean  "skip_to_first_child"
    t.boolean  "draft"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.integer  "position"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree
  add_index "pages", ["tenant_id"], name: "index_pages_on_tenant_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "title"
    t.text     "summary"
    t.text     "body"
    t.string   "link_url"
    t.string   "image"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["tenant_id"], name: "index_posts_on_tenant_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.date     "starts_on"
    t.integer  "tenant_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "pattern"
    t.integer  "position"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["page_id"], name: "index_sections_on_page_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tenants", force: :cascade do |t|
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

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "user_id"
  end

  add_index "tenants_users", ["tenant_id"], name: "index_tenants_users_on_tenant_id", using: :btree
  add_index "tenants_users", ["user_id"], name: "index_tenants_users_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "title"
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mongo_id"
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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

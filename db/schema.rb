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

ActiveRecord::Schema.define(version: 20160324232945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "blocks", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "type",       limit: 255
    t.integer  "section_id"
    t.integer  "column"
    t.integer  "position"
    t.hstore   "options"
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file",       limit: 255
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "short_name", limit: 255
    t.integer  "tenant_id"
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clubs", ["tenant_id"], name: "index_clubs_on_tenant_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "league_id"
    t.integer  "season_id"
    t.integer  "location_id"
    t.string   "type",                      limit: 255
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.integer  "duration"
    t.boolean  "all_day"
    t.string   "summary",                   limit: 255
    t.text     "description"
    t.string   "mongo_id",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "statsheet_id"
    t.string   "statsheet_type",            limit: 255
    t.integer  "home_team_score",                       default: 0
    t.integer  "away_team_score",                       default: 0
    t.string   "home_team_name",            limit: 255
    t.string   "away_team_name",            limit: 255
    t.boolean  "home_team_custom_name"
    t.boolean  "away_team_custom_name"
    t.string   "text_before",               limit: 255
    t.string   "text_after",                limit: 255
    t.string   "result",                    limit: 255
    t.string   "completion",                limit: 255
    t.boolean  "exclude_from_team_records"
  end

  add_index "events", ["away_team_id"], name: "index_events_on_away_team_id", using: :btree
  add_index "events", ["home_team_id"], name: "index_events_on_home_team_id", using: :btree
  add_index "events", ["league_id"], name: "index_events_on_league_id", using: :btree
  add_index "events", ["location_id"], name: "index_events_on_location_id", using: :btree
  add_index "events", ["season_id"], name: "index_events_on_season_id", using: :btree
  add_index "events", ["tenant_id"], name: "index_events_on_tenant_id", using: :btree

  create_table "hockey_goals", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "statsheet_id"
    t.integer  "period"
    t.integer  "minute"
    t.integer  "second"
    t.integer  "team_id"
    t.integer  "scored_by_id"
    t.integer  "scored_on_id"
    t.integer  "assisted_by_id"
    t.integer  "also_assisted_by_id"
    t.string   "strength",                limit: 255
    t.string   "mongo_id",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scored_by_number",        limit: 255
    t.string   "assisted_by_number",      limit: 255
    t.string   "also_assisted_by_number", limit: 255
  end

  add_index "hockey_goals", ["statsheet_id"], name: "index_hockey_goals_on_statsheet_id", using: :btree
  add_index "hockey_goals", ["tenant_id"], name: "index_hockey_goals_on_tenant_id", using: :btree

  create_table "hockey_goaltenders", force: :cascade do |t|
    t.string   "type",                     limit: 255
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "statsheet_id"
    t.integer  "games_played",                         default: 0
    t.integer  "minutes_played",                       default: 0
    t.integer  "shots_against",                        default: 0
    t.integer  "goals_against",                        default: 0
    t.integer  "saves",                                default: 0
    t.float    "save_percentage",                      default: 0.0
    t.float    "goals_against_average",                default: 0.0
    t.integer  "shutouts",                             default: 0
    t.integer  "shootout_attempts",                    default: 0
    t.integer  "shootout_goals",                       default: 0
    t.float    "shootout_save_percentage",             default: 0.0
    t.integer  "regulation_wins",                      default: 0
    t.integer  "regulation_losses",                    default: 0
    t.integer  "overtime_wins",                        default: 0
    t.integer  "overtime_losses",                      default: 0
    t.integer  "shootout_wins",                        default: 0
    t.integer  "shootout_losses",                      default: 0
    t.integer  "total_wins",                           default: 0
    t.integer  "total_losses",                         default: 0
    t.string   "mongo_id",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "jersey_number",            limit: 255
    t.string   "first_name",               limit: 255
    t.string   "last_name",                limit: 255
  end

  add_index "hockey_goaltenders", ["player_id"], name: "index_hockey_goaltenders_on_player_id", using: :btree
  add_index "hockey_goaltenders", ["statsheet_id"], name: "index_hockey_goaltenders_on_statsheet_id", using: :btree
  add_index "hockey_goaltenders", ["team_id"], name: "index_hockey_goaltenders_on_team_id", using: :btree
  add_index "hockey_goaltenders", ["tenant_id"], name: "index_hockey_goaltenders_on_tenant_id", using: :btree

  create_table "hockey_penalties", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "statsheet_id"
    t.integer  "period"
    t.integer  "minute"
    t.integer  "second"
    t.integer  "team_id"
    t.integer  "committed_by_id"
    t.string   "infraction",          limit: 255
    t.integer  "duration"
    t.string   "severity",            limit: 255
    t.string   "start_period",        limit: 255
    t.integer  "start_minute"
    t.integer  "start_second"
    t.string   "end_period",          limit: 255
    t.integer  "end_minute"
    t.integer  "end_second"
    t.string   "mongo_id",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "committed_by_number", limit: 255
  end

  add_index "hockey_penalties", ["statsheet_id"], name: "index_hockey_penalties_on_statsheet_id", using: :btree
  add_index "hockey_penalties", ["tenant_id"], name: "index_hockey_penalties_on_tenant_id", using: :btree

  create_table "hockey_skaters", force: :cascade do |t|
    t.string   "type",                      limit: 255
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "statsheet_id"
    t.string   "jersey_number",             limit: 255
    t.integer  "games_played",                          default: 0
    t.integer  "goals",                                 default: 0
    t.integer  "assists",                               default: 0
    t.integer  "points",                                default: 0
    t.integer  "penalties",                             default: 0
    t.integer  "penalty_minutes",                       default: 0
    t.integer  "minor_penalties",                       default: 0
    t.integer  "major_penalties",                       default: 0
    t.integer  "misconduct_penalties",                  default: 0
    t.integer  "game_misconduct_penalties",             default: 0
    t.integer  "hat_tricks",                            default: 0
    t.integer  "playmakers",                            default: 0
    t.integer  "gordie_howes",                          default: 0
    t.integer  "ejections",                             default: 0
    t.string   "mongo_id",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                limit: 255
    t.string   "last_name",                 limit: 255
  end

  add_index "hockey_skaters", ["player_id"], name: "index_hockey_skaters_on_player_id", using: :btree
  add_index "hockey_skaters", ["statsheet_id"], name: "index_hockey_skaters_on_statsheet_id", using: :btree
  add_index "hockey_skaters", ["team_id"], name: "index_hockey_skaters_on_team_id", using: :btree
  add_index "hockey_skaters", ["tenant_id"], name: "index_hockey_skaters_on_tenant_id", using: :btree

  create_table "hockey_statsheets", force: :cascade do |t|
    t.integer  "tenant_id"
    t.boolean  "posted"
    t.integer  "away_score"
    t.integer  "home_score"
    t.string   "latest_period", limit: 255
    t.integer  "latest_minute"
    t.integer  "latest_second"
    t.integer  "min_1"
    t.integer  "min_2"
    t.integer  "min_3"
    t.integer  "min_ot"
    t.integer  "away_shots_1"
    t.integer  "away_shots_2"
    t.integer  "away_shots_3"
    t.integer  "away_shots_ot"
    t.integer  "home_shots_1"
    t.integer  "home_shots_2"
    t.integer  "home_shots_3"
    t.integer  "home_shots_ot"
    t.string   "mongo_id",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hockey_statsheets", ["tenant_id"], name: "index_hockey_statsheets_on_tenant_id", using: :btree

  create_table "invoicing_ledger_items", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "type"
    t.datetime "issue_date"
    t.string   "currency",     limit: 3,                           null: false
    t.decimal  "total_amount",            precision: 20, scale: 4
    t.decimal  "tax_amount",              precision: 20, scale: 4
    t.string   "status",       limit: 20
    t.string   "identifier",   limit: 50
    t.string   "description"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "uuid",         limit: 40
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoicing_line_items", force: :cascade do |t|
    t.integer  "ledger_item_id"
    t.string   "type"
    t.decimal  "net_amount",                precision: 20, scale: 4
    t.decimal  "tax_amount",                precision: 20, scale: 4
    t.string   "description"
    t.string   "uuid",           limit: 40
    t.datetime "tax_point"
    t.decimal  "quantity",                  precision: 20, scale: 4
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoicing_tax_rates", force: :cascade do |t|
    t.string   "description"
    t.decimal  "rate",           precision: 20, scale: 4
    t.datetime "valid_from",                              null: false
    t.datetime "valid_until"
    t.integer  "replaced_by_id"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "slug",                limit: 255
    t.boolean  "show_standings"
    t.boolean  "show_players"
    t.boolean  "show_statistics"
    t.text     "standings_array",                 default: [], array: true
    t.integer  "tenant_id"
    t.string   "mongo_id",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "standings_schema_id", limit: 255
  end

  create_table "leagues_seasons", force: :cascade do |t|
    t.integer "league_id"
    t.integer "season_id"
  end

  add_index "leagues_seasons", ["league_id"], name: "index_leagues_seasons_on_league_id", using: :btree
  add_index "leagues_seasons", ["season_id"], name: "index_leagues_seasons_on_season_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "name",       limit: 255
    t.string   "short_name", limit: 255
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["tenant_id"], name: "index_locations_on_tenant_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "title",               limit: 255
    t.string   "slug",                limit: 255
    t.string   "url_path",            limit: 255
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.string   "link_url",            limit: 255
    t.boolean  "show_in_menu"
    t.string   "title_in_menu",       limit: 255
    t.boolean  "skip_to_first_child"
    t.boolean  "draft"
    t.string   "ancestry",            limit: 255
    t.integer  "ancestry_depth"
    t.integer  "position"
    t.string   "mongo_id",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree
  add_index "pages", ["tenant_id"], name: "index_pages_on_tenant_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "jersey_number", limit: 255
    t.date     "birthdate"
    t.string   "email",         limit: 255
    t.string   "slug",          limit: 255
    t.string   "mongo_id",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "substitute"
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree
  add_index "players", ["tenant_id"], name: "index_players_on_tenant_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "title",      limit: 255
    t.text     "summary"
    t.text     "body"
    t.string   "link_url",   limit: 255
    t.string   "image",      limit: 255
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["tenant_id"], name: "index_posts_on_tenant_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.date     "starts_on"
    t.integer  "tenant_id"
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "pattern",    limit: 255
    t.integer  "position"
    t.string   "mongo_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["page_id"], name: "index_sections_on_page_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "short_name",          limit: 255
    t.string   "slug",                limit: 255
    t.boolean  "show_in_standings"
    t.string   "pool",                limit: 255
    t.integer  "seed"
    t.integer  "tenant_id"
    t.integer  "league_id"
    t.integer  "season_id"
    t.integer  "club_id"
    t.string   "logo",                limit: 255
    t.string   "primary_color",       limit: 255
    t.string   "secondary_color",     limit: 255
    t.string   "accent_color",        limit: 255
    t.text     "main_colors",                     default: [], array: true
    t.boolean  "custom_colors"
    t.integer  "crop_x",                          default: 0
    t.integer  "crop_y",                          default: 0
    t.integer  "crop_h",                          default: 0
    t.integer  "crop_w",                          default: 0
    t.string   "mongo_id",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "games_played"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "ties"
    t.integer  "overtime_wins"
    t.integer  "overtime_losses"
    t.integer  "shootout_wins"
    t.integer  "shootout_losses"
    t.integer  "forfeit_wins"
    t.integer  "forfeit_losses"
    t.integer  "points"
    t.float    "percent"
    t.integer  "scored"
    t.integer  "allowed"
    t.integer  "margin"
    t.string   "last_result",         limit: 255
    t.integer  "current_run"
    t.integer  "longest_win_streak"
    t.integer  "longest_loss_streak"
  end

  add_index "teams", ["club_id"], name: "index_teams_on_club_id", using: :btree
  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree
  add_index "teams", ["season_id"], name: "index_teams_on_season_id", using: :btree
  add_index "teams", ["tenant_id"], name: "index_teams_on_tenant_id", using: :btree

  create_table "tenants", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "slug",           limit: 255
    t.string   "host",           limit: 255
    t.text     "description"
    t.string   "analytics_id",   limit: 255
    t.string   "theme",          limit: 255
    t.string   "twitter_id",     limit: 255
    t.string   "facebook_id",    limit: 255
    t.string   "instagram_id",   limit: 255
    t.string   "foursquare_id",  limit: 255
    t.string   "google_plus_id", limit: 255
    t.string   "mongo_id",       limit: 255
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
    t.string   "name",       limit: 255
    t.string   "title",      limit: 255
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mongo_id",   limit: 255
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255
    t.string   "mongo_id",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

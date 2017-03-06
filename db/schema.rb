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

ActiveRecord::Schema.define(version: 20170306171133) do

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

  create_table "clubs", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "tenant_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tenant_id"], name: "index_clubs_on_tenant_id", using: :btree
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "user_id"
    t.string   "brand",          limit: 20
    t.string   "country",        limit: 2
    t.string   "exp_month",      limit: 2
    t.string   "exp_year",       limit: 4
    t.string   "funding",        limit: 10
    t.string   "last4",          limit: 4
    t.string   "stripe_card_id"
    t.string   "token_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["stripe_card_id"], name: "index_credit_cards_on_stripe_card_id", using: :btree
    t.index ["tenant_id"], name: "index_credit_cards_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_credit_cards_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "division_id"
    t.integer  "season_id"
    t.integer  "location_id"
    t.string   "type"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.integer  "duration"
    t.boolean  "all_day"
    t.string   "summary"
    t.text     "description"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "statsheet_id"
    t.string   "statsheet_type"
    t.integer  "home_team_score",           default: 0
    t.integer  "away_team_score",           default: 0
    t.string   "home_team_name"
    t.string   "away_team_name"
    t.boolean  "home_team_custom_name"
    t.boolean  "away_team_custom_name"
    t.string   "text_before"
    t.string   "text_after"
    t.string   "result"
    t.string   "completion"
    t.boolean  "exclude_from_team_records"
    t.integer  "playing_surface_id"
    t.integer  "home_team_locker_room_id"
    t.integer  "away_team_locker_room_id"
    t.integer  "program_id"
    t.index ["away_team_id"], name: "index_events_on_away_team_id", using: :btree
    t.index ["away_team_locker_room_id"], name: "index_events_on_away_team_locker_room_id", using: :btree
    t.index ["division_id"], name: "index_events_on_division_id", using: :btree
    t.index ["home_team_id"], name: "index_events_on_home_team_id", using: :btree
    t.index ["home_team_locker_room_id"], name: "index_events_on_home_team_locker_room_id", using: :btree
    t.index ["location_id"], name: "index_events_on_location_id", using: :btree
    t.index ["mongo_id"], name: "index_events_on_mongo_id", using: :btree
    t.index ["playing_surface_id"], name: "index_events_on_playing_surface_id", using: :btree
    t.index ["program_id"], name: "index_events_on_program_id", using: :btree
    t.index ["season_id"], name: "index_events_on_season_id", using: :btree
    t.index ["tenant_id"], name: "index_events_on_tenant_id", using: :btree
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "tenant_id"
    t.integer  "location_id"
    t.integer  "parent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "preference"
    t.index ["location_id"], name: "index_facilities_on_location_id", using: :btree
    t.index ["parent_id"], name: "index_facilities_on_parent_id", using: :btree
    t.index ["tenant_id"], name: "index_facilities_on_tenant_id", using: :btree
  end

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
    t.string   "strength"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scored_by_number"
    t.string   "assisted_by_number"
    t.string   "also_assisted_by_number"
    t.index ["mongo_id"], name: "index_hockey_goals_on_mongo_id", using: :btree
    t.index ["statsheet_id"], name: "index_hockey_goals_on_statsheet_id", using: :btree
    t.index ["tenant_id"], name: "index_hockey_goals_on_tenant_id", using: :btree
  end

  create_table "hockey_goaltenders", force: :cascade do |t|
    t.string   "type"
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "statsheet_id"
    t.integer  "games_played",             default: 0
    t.integer  "minutes_played",           default: 0
    t.integer  "shots_against",            default: 0
    t.integer  "goals_against",            default: 0
    t.integer  "saves",                    default: 0
    t.float    "save_percentage",          default: 0.0
    t.float    "goals_against_average",    default: 0.0
    t.integer  "shutouts",                 default: 0
    t.integer  "shootout_attempts",        default: 0
    t.integer  "shootout_goals",           default: 0
    t.float    "shootout_save_percentage", default: 0.0
    t.integer  "regulation_wins",          default: 0
    t.integer  "regulation_losses",        default: 0
    t.integer  "overtime_wins",            default: 0
    t.integer  "overtime_losses",          default: 0
    t.integer  "shootout_wins",            default: 0
    t.integer  "shootout_losses",          default: 0
    t.integer  "total_wins",               default: 0
    t.integer  "total_losses",             default: 0
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "jersey_number"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["mongo_id"], name: "index_hockey_goaltenders_on_mongo_id", using: :btree
    t.index ["player_id"], name: "index_hockey_goaltenders_on_player_id", using: :btree
    t.index ["statsheet_id"], name: "index_hockey_goaltenders_on_statsheet_id", using: :btree
    t.index ["team_id"], name: "index_hockey_goaltenders_on_team_id", using: :btree
    t.index ["tenant_id"], name: "index_hockey_goaltenders_on_tenant_id", using: :btree
  end

  create_table "hockey_penalties", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "statsheet_id"
    t.integer  "period"
    t.integer  "minute"
    t.integer  "second"
    t.integer  "team_id"
    t.integer  "committed_by_id"
    t.string   "infraction"
    t.integer  "duration"
    t.string   "severity"
    t.string   "start_period"
    t.integer  "start_minute"
    t.integer  "start_second"
    t.string   "end_period"
    t.integer  "end_minute"
    t.integer  "end_second"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "committed_by_number"
    t.index ["mongo_id"], name: "index_hockey_penalties_on_mongo_id", using: :btree
    t.index ["statsheet_id"], name: "index_hockey_penalties_on_statsheet_id", using: :btree
    t.index ["tenant_id"], name: "index_hockey_penalties_on_tenant_id", using: :btree
  end

  create_table "hockey_skaters", force: :cascade do |t|
    t.string   "type"
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.integer  "player_id"
    t.integer  "statsheet_id"
    t.string   "jersey_number"
    t.integer  "games_played",              default: 0
    t.integer  "goals",                     default: 0
    t.integer  "assists",                   default: 0
    t.integer  "points",                    default: 0
    t.integer  "penalties",                 default: 0
    t.integer  "penalty_minutes",           default: 0
    t.integer  "minor_penalties",           default: 0
    t.integer  "major_penalties",           default: 0
    t.integer  "misconduct_penalties",      default: 0
    t.integer  "game_misconduct_penalties", default: 0
    t.integer  "hat_tricks",                default: 0
    t.integer  "playmakers",                default: 0
    t.integer  "gordie_howes",              default: 0
    t.integer  "ejections",                 default: 0
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["mongo_id"], name: "index_hockey_skaters_on_mongo_id", using: :btree
    t.index ["player_id"], name: "index_hockey_skaters_on_player_id", using: :btree
    t.index ["statsheet_id"], name: "index_hockey_skaters_on_statsheet_id", using: :btree
    t.index ["team_id"], name: "index_hockey_skaters_on_team_id", using: :btree
    t.index ["tenant_id"], name: "index_hockey_skaters_on_tenant_id", using: :btree
  end

  create_table "hockey_statsheets", force: :cascade do |t|
    t.integer  "tenant_id"
    t.boolean  "posted"
    t.integer  "away_score"
    t.integer  "home_score"
    t.string   "latest_period"
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
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["mongo_id"], name: "index_hockey_statsheets_on_mongo_id", using: :btree
    t.index ["tenant_id"], name: "index_hockey_statsheets_on_tenant_id", using: :btree
  end

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

  create_table "league_divisions", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "show_standings"
    t.boolean  "show_players"
    t.boolean  "show_statistics"
    t.text     "standings_array",     default: [], array: true
    t.integer  "tenant_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "standings_schema_id"
    t.integer  "program_id"
    t.index ["program_id"], name: "index_league_divisions_on_program_id", using: :btree
  end

  create_table "league_divisions_seasons", force: :cascade do |t|
    t.integer "division_id"
    t.integer "season_id"
    t.index ["division_id"], name: "index_league_divisions_seasons_on_division_id", using: :btree
    t.index ["season_id"], name: "index_league_divisions_seasons_on_season_id", using: :btree
  end

  create_table "league_seasons", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.date     "starts_on"
    t.integer  "tenant_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.index ["program_id"], name: "index_league_seasons_on_program_id", using: :btree
  end

  create_table "league_teams", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "slug"
    t.boolean  "show_in_standings"
    t.string   "pool"
    t.integer  "seed"
    t.integer  "tenant_id"
    t.integer  "division_id"
    t.integer  "season_id"
    t.integer  "club_id"
    t.string   "logo"
    t.string   "primary_color"
    t.string   "secondary_color"
    t.string   "accent_color"
    t.text     "main_colors",         default: [], array: true
    t.boolean  "custom_colors"
    t.integer  "crop_x",              default: 0
    t.integer  "crop_y",              default: 0
    t.integer  "crop_h",              default: 0
    t.integer  "crop_w",              default: 0
    t.string   "mongo_id"
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
    t.string   "last_result"
    t.integer  "current_run"
    t.integer  "longest_win_streak"
    t.integer  "longest_loss_streak"
    t.index ["club_id"], name: "index_league_teams_on_club_id", using: :btree
    t.index ["division_id"], name: "index_league_teams_on_division_id", using: :btree
    t.index ["season_id"], name: "index_league_teams_on_season_id", using: :btree
    t.index ["tenant_id"], name: "index_league_teams_on_tenant_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "name"
    t.string   "short_name"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tenant_id"], name: "index_locations_on_tenant_id", using: :btree
  end

  create_table "logged_exceptions", force: :cascade do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

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
    t.index ["ancestry"], name: "index_pages_on_ancestry", using: :btree
    t.index ["tenant_id"], name: "index_pages_on_tenant_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "team_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "jersey_number"
    t.date     "birthdate"
    t.string   "email"
    t.string   "slug"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "substitute"
    t.string   "position"
    t.index ["email"], name: "index_players_on_email", using: :btree
    t.index ["mongo_id"], name: "index_players_on_mongo_id", using: :btree
    t.index ["team_id"], name: "index_players_on_team_id", using: :btree
    t.index ["tenant_id"], name: "index_players_on_tenant_id", using: :btree
  end

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
    t.index ["tenant_id"], name: "index_posts_on_tenant_id", using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.index ["tenant_id"], name: "index_programs_on_tenant_id", using: :btree
  end

  create_table "rms_form_elements", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "template_id"
    t.string   "type"
    t.string   "name",        limit: 40
    t.integer  "position"
    t.hstore   "properties"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "required"
    t.index ["template_id", "name"], name: "index_rms_form_elements_on_template_id_and_name", unique: true, using: :btree
    t.index ["tenant_id"], name: "index_rms_form_elements_on_tenant_id", using: :btree
  end

  create_table "rms_form_packets", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "name",       limit: 40
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["tenant_id"], name: "index_rms_form_packets_on_tenant_id", using: :btree
  end

  create_table "rms_form_templates", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "packet_id"
    t.string   "name",       limit: 40
    t.integer  "position"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["tenant_id"], name: "index_rms_form_templates_on_tenant_id", using: :btree
  end

  create_table "rms_forms", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "registration_id"
    t.integer  "template_id"
    t.hstore   "data"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "completed",       default: false, null: false
    t.index ["tenant_id"], name: "index_rms_forms_on_tenant_id", using: :btree
  end

  create_table "rms_items", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "title",              limit: 40
    t.text     "description"
    t.integer  "quantity_allowed"
    t.integer  "quantity_available"
    t.integer  "tenant_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "active"
    t.index ["parent_type", "parent_id"], name: "index_rms_items_on_parent_type_and_parent_id", using: :btree
    t.index ["tenant_id"], name: "index_rms_items_on_tenant_id", using: :btree
  end

  create_table "rms_registrations", force: :cascade do |t|
    t.integer  "tenant_id"
    t.integer  "user_id"
    t.integer  "variant_id"
    t.integer  "credit_card_id"
    t.string   "first_name",        limit: 40
    t.string   "last_name",         limit: 40
    t.string   "email"
    t.string   "payment_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.decimal  "price",                        precision: 20, scale: 4
    t.integer  "form_packet_id"
    t.string   "confirmation_code"
    t.boolean  "active"
    t.date     "birthdate"
    t.index ["credit_card_id"], name: "index_rms_registrations_on_credit_card_id", using: :btree
    t.index ["tenant_id"], name: "index_rms_registrations_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_rms_registrations_on_user_id", using: :btree
  end

  create_table "rms_variants", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "tenant_id"
    t.string   "title",              limit: 40
    t.text     "description"
    t.decimal  "price",                         precision: 20, scale: 4
    t.integer  "quantity_allowed"
    t.integer  "quantity_available"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "form_packet_id"
    t.index ["tenant_id"], name: "index_rms_variants_on_tenant_id", using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "pattern"
    t.integer  "position"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["page_id"], name: "index_sections_on_page_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

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
    t.string   "stripe_account_id"
    t.string   "stripe_public_api_key"
    t.string   "stripe_access_token"
    t.string   "google_fonts"
    t.string   "time_zone",             default: "UTC"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "user_id"
    t.index ["tenant_id"], name: "index_tenants_users_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_tenants_users_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "title"
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mongo_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

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
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_id"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "credit_cards", "tenants"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "events", "programs"
  add_foreign_key "facilities", "locations"
  add_foreign_key "league_divisions", "programs"
  add_foreign_key "league_seasons", "programs"
  add_foreign_key "league_seasons", "programs"
  add_foreign_key "programs", "tenants"
  add_foreign_key "rms_form_elements", "rms_form_templates", column: "template_id"
  add_foreign_key "rms_form_elements", "tenants"
  add_foreign_key "rms_form_packets", "tenants"
  add_foreign_key "rms_form_templates", "rms_form_packets", column: "packet_id"
  add_foreign_key "rms_form_templates", "tenants"
  add_foreign_key "rms_forms", "rms_form_templates", column: "template_id"
  add_foreign_key "rms_forms", "rms_registrations", column: "registration_id"
  add_foreign_key "rms_forms", "tenants"
  add_foreign_key "rms_items", "tenants"
  add_foreign_key "rms_registrations", "credit_cards"
  add_foreign_key "rms_registrations", "rms_form_packets", column: "form_packet_id"
  add_foreign_key "rms_registrations", "rms_variants", column: "variant_id"
  add_foreign_key "rms_registrations", "tenants"
  add_foreign_key "rms_registrations", "users"
  add_foreign_key "rms_variants", "rms_form_packets", column: "form_packet_id"
  add_foreign_key "rms_variants", "rms_items", column: "item_id"
  add_foreign_key "rms_variants", "tenants"
end

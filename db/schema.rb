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

ActiveRecord::Schema.define(version: 2022_04_29_211308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.bigint "tenant_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["tenant_id"], name: "index_ahoy_events_on_tenant_id"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.bigint "tenant_id"
    t.index ["tenant_id"], name: "index_ahoy_visits_on_tenant_id"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "blocks", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.string "type"
    t.integer "section_id"
    t.integer "column"
    t.integer "position"
    t.hstore "options"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "file"
  end

  create_table "chromecasts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "tenant_id"
    t.integer "location_id"
    t.integer "playing_surface_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "refreshed_at"
    t.index ["location_id"], name: "index_chromecasts_on_location_id"
    t.index ["playing_surface_id"], name: "index_chromecasts_on_playing_surface_id"
    t.index ["tenant_id"], name: "index_chromecasts_on_tenant_id"
  end

  create_table "clubs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.integer "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tenant_id"], name: "index_clubs_on_tenant_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "division_id"
    t.integer "season_id"
    t.integer "location_id"
    t.string "type"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.integer "duration"
    t.boolean "all_day"
    t.string "summary"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "statsheet_id"
    t.string "statsheet_type"
    t.integer "home_team_score", default: 0
    t.integer "away_team_score", default: 0
    t.string "home_team_name"
    t.string "away_team_name"
    t.boolean "home_team_custom_name"
    t.boolean "away_team_custom_name"
    t.string "text_before"
    t.string "text_after"
    t.string "result"
    t.string "completion"
    t.boolean "exclude_from_team_records"
    t.integer "playing_surface_id"
    t.integer "home_team_locker_room_id"
    t.integer "away_team_locker_room_id"
    t.integer "program_id"
    t.integer "page_id"
    t.boolean "private", default: false, null: false
    t.index ["away_team_id"], name: "index_events_on_away_team_id"
    t.index ["away_team_locker_room_id"], name: "index_events_on_away_team_locker_room_id"
    t.index ["division_id"], name: "index_events_on_division_id"
    t.index ["home_team_id"], name: "index_events_on_home_team_id"
    t.index ["home_team_locker_room_id"], name: "index_events_on_home_team_locker_room_id"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["page_id"], name: "index_events_on_page_id"
    t.index ["playing_surface_id"], name: "index_events_on_playing_surface_id"
    t.index ["program_id"], name: "index_events_on_program_id"
    t.index ["season_id"], name: "index_events_on_season_id"
    t.index ["tenant_id"], name: "index_events_on_tenant_id"
  end

  create_table "facilities", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.integer "tenant_id"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_facilities_on_location_id"
    t.index ["tenant_id"], name: "index_facilities_on_tenant_id"
  end

  create_table "form_elements", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "template_id"
    t.string "type"
    t.string "name", limit: 40
    t.integer "position"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required"
    t.string "hint"
    t.index ["template_id", "name"], name: "index_form_elements_on_template_id_and_name", unique: true
    t.index ["tenant_id"], name: "index_form_elements_on_tenant_id"
  end

  create_table "form_packets", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "name", limit: 40
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_form_packets_on_tenant_id"
  end

  create_table "form_templates", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "packet_id"
    t.string "name", limit: 40
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_form_templates_on_tenant_id"
  end

  create_table "forms", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "registration_id"
    t.integer "template_id"
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false, null: false
    t.index ["tenant_id"], name: "index_forms_on_tenant_id"
  end

  create_table "hockey_goals", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "statsheet_id"
    t.string "period"
    t.integer "minute"
    t.integer "second"
    t.integer "team_id"
    t.integer "scored_by_id"
    t.integer "scored_on_id"
    t.integer "assisted_by_id"
    t.integer "also_assisted_by_id"
    t.string "strength"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "scored_by_number"
    t.string "assisted_by_number"
    t.string "also_assisted_by_number"
    t.index ["statsheet_id"], name: "index_hockey_goals_on_statsheet_id"
    t.index ["tenant_id"], name: "index_hockey_goals_on_tenant_id"
  end

  create_table "hockey_goaltenders", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "tenant_id"
    t.integer "team_id"
    t.integer "player_id"
    t.integer "statsheet_id"
    t.integer "games_played", default: 0
    t.integer "minutes_played", default: 0
    t.integer "shots_against", default: 0
    t.integer "goals_against", default: 0
    t.integer "saves", default: 0
    t.float "save_percentage", default: 0.0
    t.float "goals_against_average", default: 0.0
    t.integer "shutouts", default: 0
    t.integer "shootout_attempts", default: 0
    t.integer "shootout_goals", default: 0
    t.float "shootout_save_percentage", default: 0.0
    t.integer "regulation_wins", default: 0
    t.integer "regulation_losses", default: 0
    t.integer "overtime_wins", default: 0
    t.integer "overtime_losses", default: 0
    t.integer "shootout_wins", default: 0
    t.integer "shootout_losses", default: 0
    t.integer "total_wins", default: 0
    t.integer "total_losses", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "jersey_number"
    t.string "first_name"
    t.string "last_name"
    t.index ["player_id"], name: "index_hockey_goaltenders_on_player_id"
    t.index ["statsheet_id"], name: "index_hockey_goaltenders_on_statsheet_id"
    t.index ["team_id"], name: "index_hockey_goaltenders_on_team_id"
    t.index ["tenant_id"], name: "index_hockey_goaltenders_on_tenant_id"
  end

  create_table "hockey_penalties", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "statsheet_id"
    t.string "period"
    t.integer "minute"
    t.integer "second"
    t.integer "team_id"
    t.integer "committed_by_id"
    t.string "infraction"
    t.integer "duration"
    t.string "severity"
    t.string "start_period"
    t.integer "start_minute"
    t.integer "start_second"
    t.string "end_period"
    t.integer "end_minute"
    t.integer "end_second"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "committed_by_number"
    t.index ["statsheet_id"], name: "index_hockey_penalties_on_statsheet_id"
    t.index ["tenant_id"], name: "index_hockey_penalties_on_tenant_id"
  end

  create_table "hockey_skaters", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "tenant_id"
    t.integer "team_id"
    t.integer "player_id"
    t.integer "statsheet_id"
    t.string "jersey_number"
    t.integer "games_played", default: 0
    t.integer "goals", default: 0
    t.integer "assists", default: 0
    t.integer "points", default: 0
    t.integer "penalties", default: 0
    t.integer "penalty_minutes", default: 0
    t.integer "minor_penalties", default: 0
    t.integer "major_penalties", default: 0
    t.integer "misconduct_penalties", default: 0
    t.integer "game_misconduct_penalties", default: 0
    t.integer "hat_tricks", default: 0
    t.integer "playmakers", default: 0
    t.integer "gordie_howes", default: 0
    t.integer "ejections", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.index ["player_id"], name: "index_hockey_skaters_on_player_id"
    t.index ["statsheet_id"], name: "index_hockey_skaters_on_statsheet_id"
    t.index ["team_id"], name: "index_hockey_skaters_on_team_id"
    t.index ["tenant_id"], name: "index_hockey_skaters_on_tenant_id"
  end

  create_table "hockey_statsheets", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.boolean "posted"
    t.integer "away_score"
    t.integer "home_score"
    t.string "latest_period"
    t.integer "latest_minute"
    t.integer "latest_second"
    t.integer "min_1"
    t.integer "min_2"
    t.integer "min_3"
    t.integer "min_ot"
    t.integer "away_shots_1"
    t.integer "away_shots_2"
    t.integer "away_shots_3"
    t.integer "away_shots_ot"
    t.integer "home_shots_1"
    t.integer "home_shots_2"
    t.integer "home_shots_3"
    t.integer "home_shots_ot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tenant_id"], name: "index_hockey_statsheets_on_tenant_id"
  end

  create_table "league_divisions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.boolean "show_standings"
    t.boolean "show_players"
    t.boolean "show_statistics"
    t.text "standings_array", default: [], array: true
    t.integer "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "standings_schema_id"
    t.integer "program_id"
    t.integer "period_length", default: 15
    t.index ["program_id"], name: "index_league_divisions_on_program_id"
  end

  create_table "league_divisions_seasons", id: :serial, force: :cascade do |t|
    t.integer "division_id"
    t.integer "season_id"
    t.index ["division_id"], name: "index_league_divisions_seasons_on_division_id"
    t.index ["season_id"], name: "index_league_divisions_seasons_on_season_id"
  end

  create_table "league_seasons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.date "starts_on"
    t.integer "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "program_id"
    t.index ["program_id"], name: "index_league_seasons_on_program_id"
  end

  create_table "league_teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "slug"
    t.boolean "show_in_standings"
    t.string "pool"
    t.integer "seed"
    t.integer "tenant_id"
    t.integer "division_id"
    t.integer "season_id"
    t.integer "club_id"
    t.string "logo"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "accent_color"
    t.text "main_colors", default: [], array: true
    t.boolean "custom_colors"
    t.integer "crop_x", default: 0
    t.integer "crop_y", default: 0
    t.integer "crop_h", default: 0
    t.integer "crop_w", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "games_played"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.integer "overtime_wins"
    t.integer "overtime_losses"
    t.integer "shootout_wins"
    t.integer "shootout_losses"
    t.integer "forfeit_wins"
    t.integer "forfeit_losses"
    t.integer "points"
    t.float "percent"
    t.integer "scored"
    t.integer "allowed"
    t.integer "margin"
    t.string "last_result"
    t.integer "current_run"
    t.integer "longest_win_streak"
    t.integer "longest_loss_streak"
    t.index ["club_id"], name: "index_league_teams_on_club_id"
    t.index ["division_id"], name: "index_league_teams_on_division_id"
    t.index ["season_id"], name: "index_league_teams_on_season_id"
    t.index ["tenant_id"], name: "index_league_teams_on_tenant_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "name"
    t.string "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_locations_on_deleted_at"
    t.index ["tenant_id"], name: "index_locations_on_tenant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "uuid"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "user_id"
    t.bigint "tenant_id"
    t.string "session_id"
    t.string "payment_intent_id"
    t.string "confirmation_code"
    t.decimal "total_price", precision: 8, scale: 2
    t.datetime "completed_at"
    t.datetime "cancelled_at"
    t.datetime "abandoned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_orders_on_tenant_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "title"
    t.string "slug"
    t.string "url_path"
    t.text "meta_keywords"
    t.text "meta_description"
    t.string "link_url"
    t.boolean "show_in_menu"
    t.string "title_in_menu"
    t.boolean "skip_to_first_child"
    t.boolean "draft"
    t.string "ancestry"
    t.integer "ancestry_depth"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
    t.index ["ancestry"], name: "index_pages_on_ancestry"
    t.index ["tenant_id"], name: "index_pages_on_tenant_id"
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string "authenticatable_type"
    t.bigint "authenticatable_id"
    t.datetime "timeout_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "claimed_at"
    t.text "user_agent", null: false
    t.string "remote_addr", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id"
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    t.index ["tenant_id"], name: "index_passwordless_sessions_on_tenant_id"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "team_id"
    t.string "first_name"
    t.string "last_name"
    t.string "jersey_number"
    t.date "birthdate"
    t.string "email"
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "substitute"
    t.string "position"
    t.index ["email"], name: "index_players_on_email"
    t.index ["team_id"], name: "index_players_on_team_id"
    t.index ["tenant_id"], name: "index_players_on_tenant_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "title"
    t.text "summary"
    t.text "body"
    t.string "link_url"
    t.string "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tenant_id"], name: "index_posts_on_tenant_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.integer "registrable_id"
    t.string "registrable_type"
    t.string "title", limit: 40
    t.text "description"
    t.integer "quantity_allowed"
    t.integer "quantity_available"
    t.integer "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.text "summary"
    t.boolean "private"
    t.boolean "roster"
    t.index ["registrable_type", "registrable_id"], name: "index_products_on_registrable_type_and_registrable_id"
    t.index ["tenant_id"], name: "index_products_on_tenant_id"
  end

  create_table "programs", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "type"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["tenant_id"], name: "index_programs_on_tenant_id"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "user_id"
    t.integer "variant_id"
    t.string "first_name", limit: 40
    t.string "last_name", limit: 40
    t.string "email"
    t.string "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 20, scale: 4
    t.integer "form_packet_id"
    t.string "confirmation_code"
    t.date "birthdate"
    t.text "session_id"
    t.text "payment_intent_id"
    t.string "uuid"
    t.datetime "completed_at"
    t.datetime "abandoned_at"
    t.datetime "cancelled_at"
    t.datetime "checked_in_at"
    t.bigint "order_id"
    t.datetime "deleted_at"
    t.index ["order_id"], name: "index_registrations_on_order_id"
    t.index ["tenant_id"], name: "index_registrations_on_tenant_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "screens", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name"
    t.string "device_key"
    t.bigint "location_id"
    t.bigint "playing_surface_id"
    t.datetime "refreshed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_screens_on_location_id"
    t.index ["playing_surface_id"], name: "index_screens_on_playing_surface_id"
    t.index ["tenant_id"], name: "index_screens_on_tenant_id"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.string "pattern"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["page_id"], name: "index_sections_on_page_id"
  end

  create_table "stripe_connects", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "referrer"
    t.string "token"
    t.string "client"
    t.string "redirect"
    t.string "status"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_stripe_connects_on_tenant_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.string "color"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tenants", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "host"
    t.text "description"
    t.string "analytics_id"
    t.string "theme"
    t.string "twitter_id"
    t.string "facebook_id"
    t.string "instagram_id"
    t.string "foursquare_id"
    t.string "google_plus_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "stripe_account_id"
    t.string "stripe_public_api_key"
    t.string "stripe_access_token"
    t.string "google_fonts"
    t.string "time_zone", default: "UTC"
    t.text "address"
    t.string "stripe_client_id"
    t.string "stripe_private_key"
    t.string "stripe_public_key"
    t.text "style"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.integer "tenant_id"
    t.integer "user_id"
    t.index ["tenant_id"], name: "index_tenants_users_on_tenant_id"
    t.index ["user_id"], name: "index_tenants_users_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "first_name"
    t.string "last_name"
    t.string "stripe_customer_id"
    t.string "unconfirmed_email"
    t.bigint "tenant_id", null: false
    t.boolean "admin"
    t.boolean "operations"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "tenant_id"], name: "index_users_on_email_and_tenant_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "variants", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "tenant_id"
    t.string "title", limit: 40
    t.text "description"
    t.decimal "price", precision: 20, scale: 4
    t.integer "quantity_allowed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "form_packet_id"
    t.index ["tenant_id"], name: "index_variants_on_tenant_id"
  end

  create_table "vouchers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "registration_id"
    t.integer "amount"
    t.datetime "expires_at"
    t.datetime "cancelled_at"
    t.datetime "consumed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_vouchers_on_registration_id"
    t.index ["user_id"], name: "index_vouchers_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chromecasts", "facilities", column: "playing_surface_id"
  add_foreign_key "chromecasts", "locations"
  add_foreign_key "chromecasts", "tenants"
  add_foreign_key "events", "pages"
  add_foreign_key "events", "programs"
  add_foreign_key "facilities", "locations"
  add_foreign_key "form_elements", "form_templates", column: "template_id"
  add_foreign_key "form_elements", "tenants"
  add_foreign_key "form_packets", "tenants"
  add_foreign_key "form_templates", "form_packets", column: "packet_id"
  add_foreign_key "form_templates", "tenants"
  add_foreign_key "forms", "form_templates", column: "template_id"
  add_foreign_key "forms", "registrations"
  add_foreign_key "forms", "tenants"
  add_foreign_key "league_divisions", "programs"
  add_foreign_key "league_seasons", "programs"
  add_foreign_key "league_seasons", "programs"
  add_foreign_key "orders", "tenants"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "tenants"
  add_foreign_key "programs", "tenants"
  add_foreign_key "registrations", "form_packets"
  add_foreign_key "registrations", "tenants"
  add_foreign_key "registrations", "users"
  add_foreign_key "registrations", "variants"
  add_foreign_key "screens", "facilities", column: "playing_surface_id"
  add_foreign_key "screens", "locations"
  add_foreign_key "screens", "tenants"
  add_foreign_key "stripe_connects", "tenants"
  add_foreign_key "variants", "form_packets"
  add_foreign_key "variants", "products"
  add_foreign_key "variants", "tenants"
  add_foreign_key "vouchers", "registrations"
  add_foreign_key "vouchers", "users"
end

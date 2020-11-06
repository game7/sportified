# == Schema Information
#
# Table name: league_teams
#
#  id                  :integer          not null, primary key
#  accent_color        :string
#  allowed             :integer
#  crop_h              :integer          default(0)
#  crop_w              :integer          default(0)
#  crop_x              :integer          default(0)
#  crop_y              :integer          default(0)
#  current_run         :integer
#  custom_colors       :boolean
#  forfeit_losses      :integer
#  forfeit_wins        :integer
#  games_played        :integer
#  last_result         :string
#  logo                :string
#  longest_loss_streak :integer
#  longest_win_streak  :integer
#  losses              :integer
#  main_colors         :text             default([]), is an Array
#  margin              :integer
#  name                :string
#  overtime_losses     :integer
#  overtime_wins       :integer
#  percent             :float
#  points              :integer
#  pool                :string
#  primary_color       :string
#  scored              :integer
#  secondary_color     :string
#  seed                :integer
#  shootout_losses     :integer
#  shootout_wins       :integer
#  short_name          :string
#  show_in_standings   :boolean
#  slug                :string
#  ties                :integer
#  wins                :integer
#  created_at          :datetime
#  updated_at          :datetime
#  club_id             :integer
#  division_id         :integer
#  season_id           :integer
#  tenant_id           :integer
#
# Indexes
#
#  index_league_teams_on_club_id      (club_id)
#  index_league_teams_on_division_id  (division_id)
#  index_league_teams_on_season_id    (season_id)
#  index_league_teams_on_tenant_id    (tenant_id)
#
class League::TeamSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :team
  attributes :id,
    :name,
    :short_name,
    :slug,
    :show_in_standings,
    :pool,
    :seed,
    :tenant_id,
    :division_id,
    :season_id,
    :club_id,
    :logo,
    :primary_color,
    :secondary_color,
    :accent_color,
    :main_colors,
    :custom_colors,
    :crop_x,
    :crop_y,
    :crop_h,
    :crop_w,
    :created_at,
    :updated_at,
    :url

    def url
      object.id ? admin_league_team_path(object) : ''
    end
end

# == Schema Information
#
# Table name: league_teams
#
#  id                  :integer          not null, primary key
#  name                :string
#  short_name          :string
#  slug                :string
#  show_in_standings   :boolean
#  pool                :string
#  seed                :integer
#  tenant_id           :integer
#  division_id         :integer
#  season_id           :integer
#  club_id             :integer
#  logo                :string
#  primary_color       :string
#  secondary_color     :string
#  accent_color        :string
#  main_colors         :text             default([]), is an Array
#  custom_colors       :boolean
#  crop_x              :integer          default(0)
#  crop_y              :integer          default(0)
#  crop_h              :integer          default(0)
#  crop_w              :integer          default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  games_played        :integer
#  wins                :integer
#  losses              :integer
#  ties                :integer
#  overtime_wins       :integer
#  overtime_losses     :integer
#  shootout_wins       :integer
#  shootout_losses     :integer
#  forfeit_wins        :integer
#  forfeit_losses      :integer
#  points              :integer
#  percent             :float
#  scored              :integer
#  allowed             :integer
#  margin              :integer
#  last_result         :string
#  current_run         :integer
#  longest_win_streak  :integer
#  longest_loss_streak :integer
#
# Indexes
#
#  index_league_teams_on_club_id      (club_id)
#  index_league_teams_on_division_id  (division_id)
#  index_league_teams_on_season_id    (season_id)
#  index_league_teams_on_tenant_id    (tenant_id)
#

class League::Team < ActiveRecord::Base
  include ::Sportified::TenantScoped
  include ::Concerns::Brandable
  include ::Concerns::Recordable

  belongs_to :tenant
  belongs_to :division
  belongs_to :season
  has_one    :program, through: :division
  belongs_to :club, required: false

  validates_presence_of :name, :division_id, :season_id

  has_many :players

  def games
    ::League::Game.where("home_team_id = ? OR away_team_id = ?", id, id)
  end

  before_save :set_slug
  def set_slug
    self.slug = self.name.parameterize
  end

  before_save :ensure_short_name
  def ensure_short_name
    if self.short_name.nil? || self.short_name.empty?
      self.short_name = self.name
    end
  end

  class << self
    def for_division(division)
      division_id = ( division.class == League::Division ? division.id : division )
      where(:division_id => division_id)
    end
    def for_season(season)
      season_id = ( season.class == League::Season ? season.id : season )
      where(:season_id => season_id)
    end
  end

  scope :with_slug, ->(slug) { where(:slug => slug) }
end

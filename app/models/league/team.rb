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

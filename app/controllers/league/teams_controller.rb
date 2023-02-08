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

require 'icalendar'

class League::TeamsController < BaseLeagueController
  before_action :verify_admin, except: %i[show index schedule roster statistics]
  before_action :get_season_options, only: [:index]
  before_action :find_team, only: %i[edit update destroy]
  before_action :load_division_options, only: [:new]
  before_action :load_club_options, only: %i[new edit]

  def index
    @teams = @division.teams.for_season(@season).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @teams }
    end
  end

  def schedule
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first!
    @events = ::Event.where('home_team_id = ? OR away_team_id = ?', @team.id, @team.id)
                     .order(:starts_on)
                     .includes(:location, :home_team, :away_team)

    @team_links = links_to_team_schedule(@division, @season)

    respond_to do |format|
      format.html
      format.ics { to_ical(@events) }
    end
  end

  def edit; end

  def update
    @division = @team.division
    @team.update(team_params)
  end

  def roster
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first!
    @players = @team.players.order(:last_name)
    @team_links = links_to_team_roster(@division, @season)
  end

  def statistics
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first!
    @team_links = links_to_team_schedule(@division, @season)
    @players = Hockey::Skater::Record.joins(player: :team).includes(:player).where('players.team_id = ?',
                                                                                   @team.id).order(points: :desc)
    @goalies = Hockey::Goaltender::Record.joins(player: :team).includes(:player).where('players.team_id = ?',
                                                                                       @team.id).order(save_percentage: :desc)
  end

  def show
    @teams = @division.teams.for_season(@season).desc('record.pts')
    @current_game = Game.for_team(@team).in_the_future.desc(:starts_on).first
    @next_game = Game.for_team(@team).in_the_future.desc(:starts_on).skip(1).first
    @related_teams = Team.for_club(@team.club_id).order(:season_name) if @team.club_id
    @players = @team.players.order(:last_name)
  end

  private

  def team_params
    params.required(:team).permit(
      :division_id, :name, :short_name, :club_id, :pool, :show_in_standings, :seed,
      :crop_x, :crop_y, :crop_h, :crop_w, :logo, :remote_logo_url, :logo_cache,
      :primary_color, :secondary_color, :accent_color, :custom_colors
    )
  end

  def find_team
    @team = League::Team.find(params[:id])
  end

  def load_division_options
    @divisions = @season.divisions.order(:name)
  end

  def load_club_options
    @clubs = Club.order(:name)
  end

  def set_area_navigation
    super unless %i[edit update new create].include? params[:action].to_sym
  end

  def load_objects
    super
  end

  def get_season_options
    @season_options = @division.seasons.all.order(starts_on: :desc).collect do |s|
      [s.name, league_teams_path(@program.slug, @division.slug, s.slug)]
    end
  end

  def links_to_team_schedule(division, season)
    teams = @division.teams.for_season(season).order(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_path(@program.slug, division.slug, season.slug, t.slug)]
    end
  end

  def links_to_team_roster(division, season)
    teams = @division.teams.for_season(season).order(:name)
    teams.each.collect do |t|
      [t.name, league_team_roster_path(@program.slug, division.slug, season.slug, t.slug)]
    end
  end

  def to_ical(events)
    cal = Icalendar::Calendar.new
    # offset = ActiveSupport::TimeZone.new('America/Arizona').utc_offset()
    events.each do |e|
      event = Icalendar::Event.new
      event.uid = e.id.to_s
      event.dtstart = e.starts_on
      event.dtend = e.ends_on
      event.summary = e.summary
      event.location = e.location&.name
      cal.add_event event
    end
    cal.x_wr_calname = "#{@team.season.name} #{@team.division.name} #{@team.short_name}"
    cal.publish
    send_data(cal.to_ical, type: 'text/calendar',
                           disposition: "inline; filename=#{@team.slug}-#{@team.season.slug}-#{@team.division.slug}-schedule.ics", filename: "#{@team.slug}-#{@team.season.slug}-#{@team.division.slug}-schedule.ics")
  end
end

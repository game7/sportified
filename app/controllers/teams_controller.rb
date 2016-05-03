# == Schema Information
#
# Table name: teams
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  short_name          :string(255)
#  slug                :string(255)
#  show_in_standings   :boolean
#  pool                :string(255)
#  seed                :integer
#  tenant_id           :integer
#  division_id         :integer
#  season_id           :integer
#  club_id             :integer
#  logo                :string(255)
#  primary_color       :string(255)
#  secondary_color     :string(255)
#  accent_color        :string(255)
#  main_colors         :text             default([]), is an Array
#  custom_colors       :boolean
#  crop_x              :integer          default(0)
#  crop_y              :integer          default(0)
#  crop_h              :integer          default(0)
#  crop_w              :integer          default(0)
#  mongo_id            :string(255)
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
#  last_result         :string(255)
#  current_run         :integer
#  longest_win_streak  :integer
#  longest_loss_streak :integer
#

require 'icalendar'

class TeamsController < BaseLeagueController
  before_filter :verify_admin, :except => [:show, :index, :schedule, :roster, :statistics]
  before_filter :set_team_breadcrumbs, :only => [:schedule, :show, :roster]
  before_filter :get_season_options, :only => [:index]
  before_filter :find_team, :only => [:edit, :update, :destroy]
  before_filter :load_division_options, :only => [:new]
  before_filter :load_club_options, :only => [:new, :edit]

  def index
    add_breadcrumb "Teams"

    @teams = @division.teams.for_season(@season).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first
    @events = League::Game.where('home_team_id = ? OR away_team_id = ?', @team.id, @team.id).order(:starts_on).includes(:location, :home_team, :away_team)
    add_breadcrumb "Schedule"
    @team_links = links_to_team_schedule(@division, @season)

    respond_to do |format|
      format.html
      format.ics { to_ical(@events) }
    end

  end

  def edit

  end

  def update
    @division = @team.division
    @team.update_attributes(team_params)
  end

  def roster
    add_breadcrumb "Roster"
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first
    @players = @team.players.order(:last_name)
    @team_links = links_to_team_roster(@division, @season)
  end

  def statistics
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first
    add_breadcrumb "Statistics"
    @players = Hockey::Skater::Record.joins(player: :team).includes(:player).where('players.team_id = ?', @team.id).order(points: :desc)
    @goalies = Hockey::Goaltender::Record.joins(player: :team).includes(:player).where('players.team_id = ?', @team.id).order(save_percentage: :desc)
  end

  def show
    @teams = @division.teams.for_season(@season).desc("record.pts")
    @current_game = Game.for_team(@team).in_the_future().desc(:starts_on).first
    @next_game = Game.for_team(@team).in_the_future().desc(:starts_on).skip(1).first
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
    puts params[:action]
    super unless [:edit,:update,:new,:create].include? params[:action].to_sym
  end

  def set_team_breadcrumbs
    add_breadcrumb "Teams", league_teams_path(@program.slug, @division.slug)
    add_breadcrumb @team.name if @team
  end

  def load_objects
    super

  end

  def get_season_options
    @season_options = @division.seasons.all.order(starts_on: :desc).collect{|s| [s.name, league_teams_path(@program.slug, @division.slug, s.slug)]}
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
    events.each do |e|
      event = Icalendar::Event.new
      event.uid = e.id.to_s
      event.dtstart = e.starts_on
      event.dtend = e.ends_on
      event.summary = e.summary
      event.location = e.venue_name
      cal.add_event event
    end
    cal.publish
    send_data(cal.to_ical, :type => 'text/calendar', :disposition => "inline; filename=#{@team.slug}-#{@team.season_slug}-schedule.ics", :filename => "#{@team.slug}-#{@team.season_slug}-schedule.ics")
  end

end

class BaseLeagueController < ApplicationController
  skip_before_action :set_area_navigation
  before_action :find_program
  before_action :find_division
  before_action :find_season
  before_action :set_area_navigation

  private

  def set_breadcrumbs
    super
    add_breadcrumb("Programs", programs_path)
  end

  def set_area_navigation
    super
    if @division
      #add_area_menu_item('Home', "#")
      add_area_menu_item "#{@program.name} > #{@division.name}"   , nil, :header
      add_area_menu_item 'Schedule'   , league_schedule_path(@program.slug   , @division.slug)
      # add_area_menu_item 'Scoreboard' , league_scoreboard_path(@program.slug , @division.slug)
      add_area_menu_item 'Standings'  , league_standings_path(@program.slug  , @division.slug) if @division.show_standings
      add_area_menu_item 'Statistics' , league_statistics_path(@program.slug , @division.slug) if @division.show_statistics
      # add_area_menu_item 'Teams'      , league_teams_path(@program.slug      , @division.slug)
      add_area_menu_item 'Players'    , league_players_path(@program.slug    , @division.slug) if @division.show_players
    end
  end

  def find_program
    @program = ::League::Program.find_by!(slug: params[:league_slug]) if params[:league_slug]
    add_breadcrumb(@program.name, program_path(@program.slug)) if @program
  end

  def find_division
    @division = (@program.divisions || League::Division).where(slug: params[:division_slug]).first if params[:division_slug]
    add_breadcrumb(@division.name, league_schedule_path(@program.slug, @division.slug)) if @division
  end

  def find_season
    if @division
      @season = @division.seasons.find_by(slug: params[:season_slug]) if params[:season_slug]
      @season ||= @division.seasons.most_recent
      add_breadcrumb(@season.name) if @division and @season
    end
  end

end

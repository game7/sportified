class BaseLeagueController < ApplicationController
  skip_filter :set_area_navigation
  before_filter :find_program
  before_filter :find_division
  before_filter :find_season
  before_filter :set_area_navigation

  private

  def set_breadcrumbs
    super
    add_breadcrumb("Programs", programs_path)
  end

  def set_area_navigation
    super
    if @division
      #add_area_menu_item('Home', "#")
      add_area_menu_item 'Schedule'   , league_schedule_path(@program.slug   , @division.slug)
      add_area_menu_item 'Scoreboard' , league_scoreboard_path(@program.slug , @division.slug)
      add_area_menu_item 'Standings'  , league_standings_path(@program.slug  , @division.slug) if @division.show_standings
      add_area_menu_item 'Statistics' , league_statistics_path(@program.slug , @division.slug) if @division.show_statistics
      add_area_menu_item 'Teams'      , league_teams_path(@program.slug      , @division.slug)
      add_area_menu_item 'Players'    , league_players_path(@program.slug    , @division.slug) if @division.show_players
    end
  end

  def find_program
    @program = ::League::Program.with_slug(params[:league_slug]).first
    add_breadcrumb(@program.name, program_path(@program.slug))
  end

  def find_division
    @division = (@program.divisions || League::Division).where(slug: params[:division_slug]).first
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

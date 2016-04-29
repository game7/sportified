class BaseLeagueController < ApplicationController
  skip_filter :set_area_navigation
  before_filter :find_program
  before_filter :find_division
  before_filter :find_season
  before_filter :set_area_navigation

  private

  def set_breadcrumbs
    super
    add_breadcrumb("Programs")
  end

  def set_area_navigation
    super
    if @division
      #add_area_menu_item('Home', "#")
      add_area_menu_item 'Schedule', schedule_path(@division.slug)
      add_area_menu_item 'Scoreboard', scoreboard_path(@division.slug)
      add_area_menu_item 'Standings', standings_path(@division.slug) if @division.show_standings
      add_area_menu_item 'Statistics', statistics_path(@division.slug) if @division.show_statistics
      add_area_menu_item 'Teams', teams_path(@division.slug)
      add_area_menu_item 'Players', players_path(@division.slug) if @division.show_players
    end
  end

  def find_program
    @program = ::League::Program.with_slug(params[:league_slug]).first
  end

  def find_division
    @division = (@program.divisions || League::Division).where(slug: :division_slug).first
    add_breadcrumb(@division.name) if @division
  end

  def find_season
    if @division
      @season = @division.seasons.find_by(slug: params[:season_slug]) if params[:season_slug]
      @season ||= @division.seasons.most_recent
    end
  end

end

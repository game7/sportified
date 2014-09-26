class BaseLeagueController < ApplicationController
  skip_filter :set_area_navigation
  before_filter :find_league
  before_filter :find_season
  before_filter :set_area_navigation

  private

  def set_breadcrumbs
    super
    add_breadcrumb("Programs")
  end  

  def set_area_navigation
    super
    if @league
      #add_area_menu_item('Home', "#")
      add_area_menu_item 'Schedule', schedule_path(@league.slug)
      add_area_menu_item 'Scoreboard', scoreboard_path(@league.slug)
      add_area_menu_item 'Standings', standings_path(@league.slug) if @league.show_standings
      add_area_menu_item 'Statistics', statistics_path(@league.slug) if @league.show_statistics
      add_area_menu_item 'Teams', teams_path(@league.slug)
      add_area_menu_item 'Players', players_path(@league.slug) if @league.show_players
    end
  end
  
  def find_league
    @league = League.with_slug(params[:league_slug]).first
    add_breadcrumb(@league.name) if @league
  end
  
  def find_season
    if @league
      @season = @league.seasons.find_by(slug: params[:season_slug]) if params[:season_slug]
      @season ||= @league.seasons.most_recent
    end
  end

end
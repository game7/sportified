class BaseLeagueController < ApplicationController
  before_filter :find_league
  before_filter :find_season

  private

  def set_breadcrumbs
    super
    add_breadcrumb("Programs")
  end  

  def set_area_navigation
    super
    #add_area_menu_item('Home', "#")
    add_area_menu_item 'Schedule', schedule_path(@league)
    add_area_menu_item 'Scoreboard', scoreboard_path(@league)
    add_area_menu_item 'Standings', standings_path(@league)
    add_area_menu_item 'Statistics', statistics_path(@league)
    add_area_menu_item 'Teams', teams_path(@league)
    add_area_menu_item 'Players', players_path(@league)    
  end
  
  def find_league
    @league = League.with_slug(params[:league_slug]).first
    add_breadcrumb(@league.name) if @league
  end
  
  def find_season
    @season = @league.seasons.find_by(slug: params[:season_slug]) if params[:season_slug]
    @season ||= @league.seasons.most_recent
  end

end
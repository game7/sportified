class BaseLeagueController < ApplicationController
  before_filter :find_league
  before_filter :find_season

  private

  def set_breadcrumbs
    super
    #add_breadcrumb("League", path)
  end  

  def set_area_navigation
    super
    #add_area_menu_item('Home', path)
    #add_area_menu_item('Schedule', schedule_path)
    #add_area_menu_item('Scoreboard', scoreboard_path)
    ##add_area_descendant('Standings', standings_path)
    ## TODO: add_area_menu_item('Statistics')
    #add_area_menu_item('Teams', teams_path)      
  end
  
  def find_league
    @league = League.with_slug(params[:league_slug]).first
  end
  
  def find_season
    @season = @league.seasons.with_slug(params[:season_slug]).first if params[:season_slug]
    @season ||= @league.seasons.most_recent
  end

end

class League::ScoreboardController < ApplicationController
  
  before_filter :determine_division_and_season

  def determine_division_and_season
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
    @season ||= @division.seasons.order_by(:starts_on, :desc).last    
  end

  def index
    @games = @season.games.in_the_past.desc(:starts_on).entries
  end

end

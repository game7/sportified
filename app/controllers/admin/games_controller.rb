require 'chronic'
class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit]  
  before_filter :add_games_breadcrumb
  before_filter :find_game, :only => [:edit, :update]   
  before_filter :find_season, :only => [:new, :edit]
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_league_options, :only => [:new, :edit]
  before_filter :load_team_options, :only => [:new, :edit]
  before_filter :load_venue_options, :only => [:new, :edit] 
 

  def new
    @game = Game.new
    @game.season = @season if @season
    @game.venue_id = @venue_options[0].id if @venue_options.count == 1
  end

  def edit
  end

  def create
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    @game = Game.new(params[:game])
    if @game.save
      return_to_last_point :success => 'Game was successfully created.'
    else
      flash[:error] = "Game could not be created."
      find_season
      load_season_options
      load_league_options
      load_team_options
      load_venue_options
      render :action => "new"
    end
  end

  def update
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    if @game.update_attributes(params[:game])
      return_to_last_point :success => 'Game was successfully updated.'
    else
      flash[:error] = "Game could not be updated."
      find_season
      load_season_options
      load_league_options
      load_team_options
      load_venue_options     
      render :action => "edit"
    end
  end
  
  private
  
  def add_games_breadcrumb
    add_breadcrumb 'Games', admin_games_path  
  end

  def load_season_options
    @season_options = Season.desc(:starts_on)
  end
  
  def load_league_options
    @league_options = []    
    @league_options = @season.leagues.asc(:name) if @season
  end  

  def load_venue_options
    @venue_options = Venue.asc(:name).entries
  end

  def load_team_options
    @team_options = []
    if @season and @game and @game.league_id
      puts 'TEAMS!!!'
      @team_options = @season.teams.for_league(@game.league_id).asc(:name).entries.collect do |team|
        [ team.name, team.id ]
      end
    end
  end

  def find_game
    @game = Game.find(params[:id])  
  end

  def find_season
    @season = @game.season if @game
    @season ||= Season.find(params[:season_id]) if params[:season_id]
    @season ||= Season.most_recent 
  end

end

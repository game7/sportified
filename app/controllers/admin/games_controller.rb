require 'chronic'
class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit]  
  before_filter :add_games_breadcrumb
  before_filter :find_game, :only => [:edit, :update]   
  before_filter :find_season, :only => [:new, :edit]
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_league_options, :only => [:new, :edit]
  before_filter :load_team_options, :only => [:edit]
  before_filter :load_venue_options, :only => [:new, :edit] 
 

  def new
    if params[:clone]
      clone = Game.find(params[:clone])
      @game = clone.dup
    else
      @game = Game.new
      @game.season = @season if @season
      @game.league_id = params[:league_id] || @league_options.first.id if @league_options.length == 1
      @game.league = @league if @league
      @game.venue_id = @venue_options.first.id if @venue_options.length == 1
    end
    load_team_options
  end

  def edit
  end

  def create
    Chronic.time_class = Time.zone
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    @game = Game.new(game_params)
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
    Chronic.time_class = Time.zone
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    if @game.update_attributes(game_params)
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
  
  def game_params
    params.require(:game).permit(:season_id, :league_id, :starts_on, :duration, 
      :venue_id, :summary, :description, :show_for_all_teams,
      :away_team_id, :away_custom_name, :away_team_name,
      :home_team_id, :home_custom_name, :home_team_name,
      :text_before, :text_after, :show_for_all_teams
    )    
  end
  
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

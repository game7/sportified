require 'chronic'
class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit]  
  before_filter :add_games_breadcrumb
  before_filter :load_season_options, :only => [:index, :new, :edit]
  before_filter :load_division_options, :only => [:index, :new, :edit]  
  before_filter :load_venue_options, :only => [:new, :edit] 
  before_filter :find_game, :only => [:show, :edit, :update, :destroy]  
  before_filter :load_division, :only => [:index]
  before_filter :load_season, :only => [:index] 
  before_filter :load_games, :only => [:index]

  def index
  end

  def new
    @game = Game.new
    @game.season_id = params[:season_id]
    @game.venue_id = @venues[0].id if @venues.count
    load_team_options
  end

  def edit
    load_team_options @game.season
  end

  def create
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    @game = Game.new(params[:game])
    if @game.save
      return_to_last_point :success => 'Game was successfully created.'
    else
      flash[:error] = "Game could not be created."
      load_season_options
      load_team_options
      load_venue_options
      load_division_options
      render :action => "new"
    end
  end

  def update
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    if @game.update_attributes(params[:game])
      return_to_last_point :success => 'Game was successfully updated.'
    else
      flash[:error] = "Game could not be updated."
      load_season_options
      load_team_options
      load_venue_options     
      load_division_options
      render :action => "edit"
    end
  end
  
  private
  
  def add_games_breadcrumb
    add_breadcrumb 'Games', admin_games_path  
  end

  def load_season_options
    @seasons = Season.desc(:starts_on).entries
  end

  def load_division_options
    @divisions = Division.asc(:name).entries
  end

  def load_venue_options
    @venues = Venue.asc(:name).entries
  end

  def load_team_options(season = nil)
    @teams = []
    if season
      @teams = season.teams.asc(:name).entries.collect do |team|
        [ "#{team.name} (#{team.division_name} Division)", team.id ]
      end
    end
  end

  def find_game
    @game = Game.find(params[:id])  
  end

  def load_division
    @division = Division.find(params[:division_id]) if params[:division_id]
  end

  def load_season
    @season = Season.find(params[:season_id]) if params[:season_id]    
  end

  def load_games
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 14
    @days_in_past = 7
    @start_date = @date - @days_in_past - 1
    @end_date = @date + @days_in_future + 1
    @next_date = @date + @days_in_future + @days_in_past
    @prev_date = @date - @days_in_future - @days_in_past

    @games = Game.all  
    @games = @games.for_division(@division) if @division
    @games = @games.for_season(@season) if @season
    @games = @games.between(@start_date, @end_date) unless @division.present? || @season.present?
    @games = @games.asc(:starts_on)    
  end  

end

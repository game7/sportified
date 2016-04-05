require 'chronic'
class Admin::GamesController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit]
  before_filter :add_games_breadcrumb
  before_filter :find_game, :only => [:edit, :result, :update]
  before_filter :find_season, :only => [:new, :edit]
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_division_options, :only => [:new, :edit]
  before_filter :load_team_options, :only => [:edit]
  before_filter :load_location_options, :only => [:new, :edit]
  before_filter :load_playing_surface_options, :only => [:new, :edit]
  before_filter :load_locker_room_options, :only => [:new, :edit]


  def new
    if params[:clone]
      clone = Game.find(params[:clone])
      @game = clone.dup
    else
      @game = Game.new
      @game.season = @season if @season
      @game.division_id = params[:division_id] || @division_options.first.id if @division_options.length == 1
      @game.division = @division if @division
      @game.location_id = @location_options.first.id if @location_options.length == 1
      @game.playing_surface_id = @playing_surface_options.first.id if @playing_surface_options.length ==1
    end
    load_team_options
  end

  def edit
  end

  def result
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
      load_division_options
      load_team_options
      load_location_options
      load_playing_surface_options
      load_locker_room_options
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
      load_division_options
      load_team_options
      load_location_options
      load_playing_surface_options
      load_locker_room_options
      render :action => "edit"
    end
  end

  private

  def game_params
    params.require(:game).permit(:season_id, :division_id, :starts_on, :duration,
      :location_id, :summary, :description, :show_for_all_teams,
      :away_team_id, :away_team_custom_name, :away_team_name,
      :home_team_id, :home_team_custom_name, :home_team_name,
      :text_before, :text_after, :show_for_all_teams,
      :away_team_score, :home_team_score, :completion, :result,
      :playing_surface_id, :home_team_locker_room_id, :away_team_locker_room_id
    )
  end

  def add_games_breadcrumb
    add_breadcrumb 'Games', admin_games_path
  end

  def load_season_options
    @season_options = Season.order(:starts_on => :desc)
  end

  def load_division_options
    @division_options = []
    @division_options = @season.divisions.order(:name) if @season
  end

  def load_location_options
    @location_options = Location.order(:name)
  end

  def load_playing_surface_options
    @playing_surface_options = PlayingSurface.order(:name)
  end

  def load_locker_room_options
    @locker_room_options = LockerRoom.order(:name)
  end

  def load_team_options
    @team_options = []
    if @season and @game and @game.division_id
      @team_options = @season.teams.for_division(@game.division_id).order(:name).entries.collect do |team|
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

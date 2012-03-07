require 'csv'
require 'open-uri'

class Admin::PlayerImportsController < Admin::BaseLeagueController
  
  before_filter :add_players_breadcrumb
  before_filter :find_player_import, :only => [:edit, :update, :complete]
  before_filter :load_season_options, :only => [:new]
  before_filter :load_league_options, :only => [:new]
  before_filter :load_team_options, :only => [:edit, :update] 

  def new 
    add_breadcrumb 'New'
    @player_import = Player::Import.new
  end

  def create
    if params[:player_import][:contents]
      contents = CSV.parse(params[:player_import][:contents].read)
      params[:player_import].delete :contents
    end
    @player_import = Player::Import.new(params[:player_import])
    @player_import.contents = contents if contents
    if @player_import.save
      redirect_to edit_admin_player_import_path(@player_import.id), :success => "Player Import has been created."
    else
      flash[:error] = "Player Import could not be created."
      find_season
      load_season_options
      load_league_options
      render :action => "new"
    end
  end

  def edit
    add_breadcrumb 'Edit'
    #set defaults
    @player_import.teams.each do |map|
      @team_options.each do |option|
        if map.team_id == nil
          if map.name.include? option[0] or option[0].include? map.name
            map.team_id = option[1]
            break
          end
        end
      end
    end
  end

  def update
    if @player_import.update_attributes(params[:player_import])
      redirect_to admin_player_imports_path, :notice => 'Player Import was successfully updated.'
    else
      render :action => "edit"    
    end
  end

  def complete
    unless @player_import.can_complete?
      flash.now[:error] = 'Player Import is not ready for completion'
      render :action => "index"
    else
      processor = Player::Import::Processor.new(@player_import)
      processor.build_players!
      processor.complete!
      redirect_to admin_player_imports_path, :success => "#{processor.players.length} Players have been successfully imported"
    end

  end

  def index
    @player_imports = Player::Import.desc(:created_at)
  end
  
  private
  
  def add_players_breadcrumb
    add_breadcrumb 'Teams', admin_teams_path  
    add_breadcrumb 'Player Imports', admin_player_imports_path
  end
  
  def find_player_import
    @player_import = Player::Import.find(params[:id])
  end
  
  def find_season
    @season = @player_import.season if @player_import
  end

  def load_season_options
    @season_options = Season.desc(:starts_on)
  end
  
  def load_league_options
    @league_options = []
    @league_options = @season.leagues.desc(:starts_on) if @season
  end  

  def load_team_options
    @team_options = []
    if @player_import
      @team_options = Team.for_season(@player_import.season_id).for_league(@player_import.league_id).asc(:name).entries.collect do |team|
        [ team.name, team.id ]
      end
    end
  end

end

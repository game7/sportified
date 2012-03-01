require 'csv'
require 'open-uri'

class League::Admin::GameImportsController < League::Admin::BaseLeagueController
  
  before_filter :add_games_breadcrumb
  before_filter :find_game_import, :only => [:edit, :update, :complete]
  before_filter :load_season_options, :only => [:new, :create]    
  before_filter :load_team_options, :only => [:edit, :update]
  before_filter :load_venue_options, :only => [:edit, :update]  

  def new
    add_breadcrumb 'New'
    @game_import = Game::Import.new
  end

  def create
    if params[:game_import][:contents]
      contents = CSV.parse(params[:game_import][:contents].read)
      params[:game_import].delete :contents
    end
    @game_import = Game::Import.new(params[:game_import])
    @game_import.contents = contents if contents
    if @game_import.save
      redirect_to edit_league_admin_game_import_path(@game_import.id), :success => "Game Upload has been created."
    else
      flash[:error] = "Game Upload could not be created."
      render :action => "new"
    end
  end

  def edit
    add_breadcrumb 'Edit'   
  end

  def update
    if @game_import.update_attributes(params[:game_import])
      redirect_to league_admin_game_imports_path, :notice => 'Game Upload was successfully updated.'
    else
      render :action => "edit"    
    end
  end

  def complete
    unless @game_import.can_complete?
      flash.now[:error] = 'Game Upload is not ready for completion'
      render :action => "index"
    else
      processor = Game::Import::Processor.new(@game_import)
      processor.build_games!
      processor.complete!
      redirect_to league_admin_game_imports_path, :success => "#{processor.games.length} Games have been successfully imported"
    end

  end

  def index
    @game_imports = Game::Import.desc(:created_at)
  end
  
  private
  
  def add_games_breadcrumb
    add_breadcrumb 'Events', league_admin_events_path  
    add_breadcrumb 'Game Uploads', league_admin_game_imports_path
  end
  
  def find_game_import
    @game_import = Game::Import.find(params[:id])
  end

  def load_season_options
    @season_options = Season.desc(:starts_on)
  end

  def load_team_options
    @team_options = Team.asc(:name).entries.collect do |team|
      [ "#{team.name} (#{team.division_name} Division)", team.id ]
    end
  end

  def load_venue_options
    @venue_options = Venue.asc(:name)
  end


end

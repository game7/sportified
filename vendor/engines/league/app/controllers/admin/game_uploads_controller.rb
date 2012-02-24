require 'csv'
require 'open-uri'

class Admin::GameUploadsController < Admin::BaseLeagueController
  
  before_filter :add_games_breadcrumb
  before_filter :find_game_upload, :only => [:edit, :update, :complete]
  before_filter :load_season_options, :only => [:new, :create]    
  before_filter :load_team_options, :only => [:edit, :update]
  before_filter :load_venue_options, :only => [:edit, :update]  

  def new
    add_breadcrumb 'New'
    @game_upload = GameUpload.new
  end

  def create
    if params[:game_upload][:contents]
      contents = CSV.parse(params[:game_upload][:contents].read)
      params[:game_upload].delete :contents
    end
    @game_upload = GameUpload.new(params[:game_upload])
    @game_upload.contents = contents if contents
    if @game_upload.save
      redirect_to edit_admin_game_upload_path(@game_upload.id), :success => "Game Upload has been created."
    else
      flash[:error] = "Game Upload could not be created."
      render :action => "new"
    end
  end

  def edit
    add_breadcrumb 'Edit'   
  end

  def update
    if @game_upload.update_attributes(params[:game_upload])
      redirect_to admin_game_uploads_path, :notice => 'Game Upload was successfully updated.'
    else
      render :action => "edit"    
    end
  end

  def complete
    unless @game_upload.can_complete?
      flash.now[:error] = 'Game Upload is not ready for completion'
      render :action => "index"
    else
      processor = GameUploadProcessor.new(@game_upload)
      processor.build_games!
      processor.complete!
      redirect_to admin_game_uploads_path, :success => "#{processor.games.length} Games have been successfully uploaded"
    end

  end

  def index
    @game_uploads = GameUpload.desc(:created_at)
  end
  
  private
  
  def add_games_breadcrumb
    add_breadcrumb 'Events', admin_events_path  
    add_breadcrumb 'Game Uploads', admin_game_uploads_path
  end
  
  def find_game_upload
    @game_upload = GameUpload.find(params[:id])
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

require 'csv'
require 'open-uri'

class Admin::GameUploadsController < Admin::BaseLeagueController
  
  before_filter :add_games_breadcrumb
  def add_games_breadcrumb
    add_breadcrumb 'Events', admin_events_path  
    add_breadcrumb 'Game Uploads', admin_game_uploads_path
  end

  before_filter :load_game_upload, :only => [:edit, :update, :complete]
  def load_game_upload
    @game_upload = GameUpload.find(params[:id])
  end

  before_filter :load_season_options, :only => [:new, :create]
  def load_season_options
    @season_options = Season.for_site(Site.current).desc(:starts_on)
  end

  before_filter :load_team_options, :only => [:edit, :update]
  def load_team_options
    @team_options = Team.for_season(@game_upload.season_id).asc(:name).entries.collect do |team|
      [ "#{team.name} (#{team.division_name} Division)", team.id ]
    end
  end

  before_filter :load_venue_options, :only => [:edit, :update]
  def load_venue_options
    @venue_options = Venue.for_site(Site.current).asc(:name)
  end

  def new
    add_breadcrumb 'New'
    @game_upload = GameUpload.new
  end

  def create
    @game_upload = GameUpload.new(params[:game_upload])
    @game_upload.site = Site.current
    if @game_upload.save
      redirect_to edit_admin_game_upload_path(@game_upload.id)
    else
      render :action => "new"
    end
  end

  def edit
    add_breadcrumb 'Edit'    
    @game_data = CSV.parse(open(@game_upload.file.path).read)
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
      flash.now[:error] = 'Game Upload is not ready for completion'
      redirect_to admin_game_uploads_path, :notice => "#{processor.games.length} Games successfully uploaded"
    end

  end

  def index
    @game_uploads = GameUpload.for_site(Site.current).desc(:created_at)
  end


end

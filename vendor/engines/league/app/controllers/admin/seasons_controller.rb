class Admin::SeasonsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_seasons_breadcrumb  
  before_filter :load_season, :only => [:show, :edit]

  def add_seasons_breadcrumb
    add_new_breadcrumb 'Seasons', admin_seasons_path    
  end

  def load_season
    @season = Season.find(params[:id])

    add_new_breadcrumb @season.name

    #load_area_navigation @division, @season

  end

 
  # GET /seasons
  def index
    
    @seasons = Season.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /seasons/1
  def show

    @teams = @season.teams

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  def new

    @season = Season.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /seasons/1/edit
  def edit

  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @season = Season.new(params[:season])

    respond_to do |format|
      if @season.save
        format.html { return_to_last_point(:notice => 'Season was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /seasons/1
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        format.html { return_to_last_point(:notice => 'Season was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /seasons/1
  def destroy
    @season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Season has been deleted.') }
    end
  end
end

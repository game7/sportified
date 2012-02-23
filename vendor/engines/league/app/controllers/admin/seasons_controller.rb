class Admin::SeasonsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_seasons_breadcrumb  
  before_filter :load_season, :only => [:show, :edit, :delete]
  before_filter :load_seasons, :only => [:index]
  before_filter :load_division_options, :only => [:new, :edit]

  def add_seasons_breadcrumb
    add_breadcrumb 'Seasons', admin_seasons_path    
  end

  def load_division_options
    @division_options = Division.for_site(Site.current).asc(:name).entries    
  end

  def load_season
    @season = Season.for_site(Site.current).find(params[:id])
    add_breadcrumb @season.name
  end

  def load_seasons
    @seasons = Season.for_site(Site.current).asc(:name)
  end

 
  # GET /seasons
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /seasons/1
  def show

    @divisions = @season.divisions

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
    @season.site = Site.current
    respond_to do |format|
      if @season.save
        format.html { return_to_last_point(:notice => 'Season was successfully created.') }
      else
        load_division_options
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
        load_division_options        
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /seasons/1
  def destroy
    @season.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Season has been deleted.') }
    end
  end
end

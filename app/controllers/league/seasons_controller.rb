class League::SeasonsController < League::BaseSeasonController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]    
  before_filter :load_for_season, :only => [:show, :edit]
  before_filter :load_for_division, :only => [:index, :new]

  def load_for_season
    
    if params[:id]
      @season = Season.find(params[:id])
      @division = @season.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
    end

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name

    load_area_navigation @division, @season

  end

  def load_for_division
    
    @division = Division.find(params[:division_id])

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)    

  end
  
  # GET /seasons
  # GET /seasons.xml
  def index

    @seasons = @division.seasons

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.xml
  def show

    @teams = @season.teams

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new

    @season = @division.seasons.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit

  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @division = Division.find(params[:division_id])
    @season = @division.seasons.build(params[:season])

    respond_to do |format|
      if @season.save
        format.html { return_to_last_point(:notice => 'Season was successfully created.') }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        format.html { return_to_last_point(:notice => 'Season was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    @season = Season.find(params[:id])
    @division = @season.division
    @season.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Season has been deleted.') }
      format.xml  { head :ok }
    end
  end
end

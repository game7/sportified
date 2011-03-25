class Admin::DivisionsController < Admin::BaseLeagueController
  
  before_filter :add_divisions_breadcrumb
  before_filter :load_division, :only => [:show, :edit, :destroy, :standings]
  before_filter :load_divisions, :only => [:index]
  before_filter :load_seasons, :only => [:new, :edit]
  before_filter :load_standings_layouts, :only => [:new, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def add_divisions_breadcrumb
    add_breadcrumb 'Divisions', admin_divisions_path    
  end

  def load_division
    @division = Division.for_site(Site.current).find(params[:id])  
    add_breadcrumb @division.name
  end

  def load_divisions
    @divisions = Division.for_site(Site.current).asc(:name)    
  end

  def load_seasons
    @all_seasons = Season.for_site(Site.current).desc(:starts_on).entries    
  end

  def load_standings_layouts
    @standings_layouts = StandingsLayout.for_site(Site.current).desc(:name).entries    
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @seasons = @division.seasons

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def standings
    @columns = @division.standings_columns.asc(:order).entries

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @division = Division.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit

  end

  def create
    @division = Division.new(params[:division])
    @division.site = Site.current
    if params[:division][:seasons]
      params[:division][:seasons].each do |id|
        season = Season.find(id)
        @division.seasons << season if season
      end
    end

    respond_to do |format|
      if @division.save
        format.html { return_to_last_point(:notice => 'Division was successfully created.') }
      else
        load_seasons
        load_standings_layouts
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @division = Division.find(params[:id])
    # clear out season_ids so that non selected items are removed (because not re-added below)
    @division.season_ids = []
    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { return_to_last_point(:notice => 'Division was successfully updated.') }
      else
        load_seasons
        load_standings_layouts
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @division.destroy

    respond_to do |format|
      format.html { redirect_to(admin_divisions_url) }
    end
  end
end

class Admin::DivisionsController < Admin::BaseLeagueController
  
  before_filter :add_divisions_breadcrumb
  before_filter :load_division, :only => [:show, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def add_divisions_breadcrumb
    add_new_breadcrumb 'Divisions', admin_divisions_path    
  end

  def load_division
    @division = Division.find(params[:id])  
    add_new_breadcrumb @division.name
    #load_area_navigation @division
  end

  # GET /divisions
  def index
    @divisions = Division.asc(:name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /divisions/1
  def show
    @seasons = @division.seasons

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /divisions/new
  def new
    @division = Division.new
    @all_seasons = Season.all.desc(:starts_on).entries

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /divisions/1/edit
  def edit
    @all_seasons = Season.all.desc(:starts_on).entries
  end

  # POST /divisions
  def create
    @division = Division.new(params[:division])
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
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /divisions/1
  def update
    @division = Division.find(params[:id])
    # clear out season_ids so that non selected items are removed (because not re-added below)
    @division.season_ids = []
    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { return_to_last_point(:notice => 'Division was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /divisions/1
  def destroy
    @division = Division.find(params[:id])
    @division.destroy

    respond_to do |format|
      format.html { redirect_to(admin_divisions_url) }
    end
  end
end

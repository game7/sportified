class League::DivisionsController < League::BaseDivisionController
  
  before_filter :load_for_division, :only => [:show, :edit]
  before_filter :mark_return_point, :only => [:new, :edit]

  def load_for_division
    @division = params[:division_slug] ? Division.with_slug(params[:division_slug]).first : Division.find(params[:id])  
    add_new_breadcrumb @division.name
    load_area_navigation @division
  end

  # GET /divisions
  # GET /divisions.xml
  def index
    @divisions = Division.asc(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @divisions }
    end
  end

  # GET /divisions/1
  # GET /divisions/1.xml
  def show
    @seasons = @division.seasons

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @division }
    end
  end

  # GET /divisions/new
  # GET /divisions/new.xml
  def new
    @division = Division.new
    @all_seasons = Season.all.desc(:starts_on).entries

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @division }
    end
  end

  # GET /divisions/1/edit
  def edit
    @all_seasons = Season.all.desc(:starts_on).entries
  end

  # POST /divisions
  # POST /divisions.xml
  def create
    @division = Division.new(params[:division])

    respond_to do |format|
      if @division.save
        format.html { return_to_last_point(:notice => 'Division was successfully created.') }
        format.xml  { render :xml => @division, :status => :created, :location => @division }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /divisions/1
  # PUT /divisions/1.xml
  def update
    @division = Division.find(params[:id])
    # clear out season_ids so that non selected items are removed (because not re-added below)
    @division.season_ids = []
    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { return_to_last_point(:notice => 'Division was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.xml
  def destroy
    @division = Division.find(params[:id])
    @division.destroy

    respond_to do |format|
      format.html { redirect_to(league_url) }
      format.xml  { head :ok }
    end
  end
end

class League::TeamsController < League::BaseSeasonController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :load_for_team, :only => [:show, :edit]
  before_filter :load_for_season, :only => [:index, :new]

  def load_for_team
    
    if params[:id]
      @team = Team.find(params[:id])
      @season = @team.season
      @division = @season.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @team = @season.teams.with_slug(params[:team_slug]).first
    end

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name, league_season_friendly_path(@division.slug, @season.slug)
    add_new_breadcrumb @team.name

    load_area_navigation @division, @season
  end

  def load_for_season
    if params[:season_id]
      @season = Season.find(params[:season_id])
      @division = @season.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
    end

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name, league_season_friendly_path(@division.slug, @season.slug)

    load_area_navigation @division, @season
    
  end

  # GET /teams
  # GET /teams.xml
  def index
    @season ||= Season.find(params[:season_id])
    @teams = @season.teams.asc(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team ||= Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @season = Season.find(params[:season_id])
    @team = @season.teams.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @season = Season.find(params[:season_id])
    @team = @season.teams.build(params[:team])

    respond_to do |format|
      if @team.save
        format.html { return_to_last_point(:notice => 'Team was successfully created.') }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])
    @season = @team.season
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { return_to_last_point(:notice => 'Team was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @season = @team.season
    @team.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Team has been deleted.') }
      format.xml  { head :ok }
    end
  end
end

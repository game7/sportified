class League::TeamsController < League::LeagueController
  
  before_filter :determine_division_and_season_and_team, :only => [:index, :show]

  def determine_division_and_season_and_team
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
    @season ||= @division.seasons.order_by(:starts_on, :desc).last    
    @team = @season.teams.with_slug(params[:team_slug]).first if params[:team_slug]
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
        format.html { redirect_to(league_season_path(@team.season_id), :notice => 'Team was successfully created.') }
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

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to(league_season_path(@team.season_id), :notice => 'Team was successfully updated.') }
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
    @season_id = @team.season_id
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(league_season_url(@season_id)) }
      format.xml  { head :ok }
    end
  end
end

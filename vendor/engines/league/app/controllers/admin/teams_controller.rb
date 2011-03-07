class Admin::TeamsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_teams_breadcrumb
  before_filter :load_division, :only => [:index]
  before_filter :load_season, :only => [:index]
  before_filter :load_division_options, :only => [:index, :new, :edit]
  before_filter :load_season_options, :only => [:index, :new, :edit]
  before_filter :load_team, :only => [:show, :edit, :schedule]

  def add_teams_breadcrumb
    add_new_breadcrumb 'Teams', admin_teams_path  
  end

  def load_division
    @division = Division.find(params[:division_id]) if params[:division_id]
  end

  def load_season
    @season = Season.find(params[:season_id]) if params[:season_id]    
  end

  def load_division_options
    @divisions = Division.all.asc(:name).entries
  end

  def load_season_options
    @seasons = Season.all.desc(:starts_on).entries
  end

  def load_team
    
    @team = Team.find(params[:id])
    @division = @team.division
    @season = @team.season

    add_new_breadcrumb @division.name
    add_new_breadcrumb @season.name
    add_new_breadcrumb @team.name

    #load_area_navigation @division
  end

  #def load_for_division
  #  
  #  @division = params[:division_id] ? Division.find(params[:division_id]) : Division.with_slug(params[:division_slug]).first
  #  @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.default_season
#
  #  add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
  #  add_new_breadcrumb @season.name if @season#, league_season_friendly_path(@division.slug, @season.slug)
#
  #  load_area_navigation @division
  #  
  #end
#
  #def links_to_team_schedule(division, season)
  #  teams = division.teams.for_season(season).asc(:name)
  #  teams.each.collect do |t|
  #    [t.name, league_team_schedule_friendly_path(division.slug, season.slug, t.slug)] 
  #  end   
  #end

  # GET /teams
  # GET /teams.xml
  
  def index
    @teams = Team.all
    @teams = @teams.for_division(@division) if @division
    @teams = @teams.for_season(@season) if @season
    @teams = @teams.asc(:name).entries

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

  def new
    @team = Team.new
    @team.division_id = params[:division_id]
    @team.season_id = params[:season_id]

    add_new_breadcrumb 'New'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /teams/1/edit
  def edit

  end

  # POST /teams
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { return_to_last_point(:notice => 'Team was successfully created.') }
      else
        self.load_division_options
        self.load_season_options
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { return_to_last_point(:notice => 'Team was successfully updated.') }
      else
        self.load_division_options
        self.load_season_options
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /teams/1
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.js do
        @season = @team.season
        @division = @team.division
        @teams = @division.teams.for_season(@team.season_id).asc(:name).entries
      end
      format.html { return_to_last_point(:notice => 'Team has been deleted.') }
    end
  end
end

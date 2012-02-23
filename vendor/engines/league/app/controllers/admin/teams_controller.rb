class Admin::TeamsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_teams_breadcrumb
  before_filter :find_season, :only => [:index, :new, :create]
  before_filter :load_teams, :only => [:index]
  before_filter :load_division_options, :only => [:new, :edit]
  before_filter :load_club_options, :only => [:new, :edit]
  before_filter :load_season_links, :only => [:index]
  before_filter :find_team, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
      format.json { render :json => @teams }
    end
  end

  def show
    @team ||= Team.find(params[:id])
  end

  def new
    @team = @season.teams.build
    @team.division_id = params[:division_id]
    add_breadcrumb 'New'
  end

  def edit
  end

  def create
    @team = @season.teams.build params[:team]
    @team.site = Site.current
    if @team.save
      return_to_last_point :success => 'Team was successfully created.'
    else
      flash[:error] = "Team could not be created."
      load_division_options
      load_club_options
      render :action => "new"
    end
  end

  def update
    if @team.update_attributes(params[:team])
      return_to_last_point :success => 'Team was successfully updated.'
    else
      flash[:error] = "Team could not be updated."
      load_division_options
      load_club_options
      render :action => "edit"
    end
  end

  def destroy
    @team.destroy
    return_to_last_point :success => 'Team has been deleted.'
  end
  
  private

  def load_teams
    @teams = Team.for_site(Site.current)
    @teams = @teams.for_division(@division) if @division
    @teams = @teams.for_season(@season) if @season
    @teams = @teams.asc(:division_name).asc(:name).entries    
  end

  def find_team    
    @team = Team.for_site(Site.current).find(params[:id])
    @season = @team.season
    @division = @team.division
    add_breadcrumb @season.name
    add_breadcrumb @division.name    
    add_breadcrumb @team.name
  end  
  
  def add_teams_breadcrumb
    add_breadcrumb 'Teams', admin_teams_path  
  end

  def find_season
    @season = Season.for_site(Site.current).find(params[:season_id]) if params[:season_id]   
    @season ||= Season.for_site(Site.current).most_recent()
  end
  
  def load_division_options
    season = @season
    season ||= @team.season
    @divisions = season.divisions.asc(:name)
  end

  def load_club_options
    @clubs = Club.for_site(Site.current).asc(:name).entries
  end

  def load_season_links
    @season_links = Season.for_site.each.collect do |s|
      [s.name, admin_teams_path(:season_id => s.id)]
    end
  end
end

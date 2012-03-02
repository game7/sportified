class Admin::TeamsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_teams_breadcrumb
  before_filter :find_season, :only => [:index, :new, :create]
  before_filter :load_season_links, :only => [:index]
  before_filter :load_league_links, :only => [:index]
  before_filter :find_team, :only => [:show, :edit, :update, :destroy]
  before_filter :load_league_options, :only => [:new]
  before_filter :load_division_options, :only => [:new, :edit]
  before_filter :load_club_options, :only => [:new, :edit]

  def index
    @teams = Team.all
    @teams = @teams.for_league(params[:league_id]) if params[:league_id]  
    @teams = @teams.for_season(@season) if @season
    @teams = @teams.asc(:name)
    @leagues = @season.leagues.asc(:name)
    @leagues = @leagues.where(:_id => params[:league_id]) if params[:league_id]    
    respond_to do |format|
      format.html
      format.json { render :json => @teams.entries }
    end
  end

  def show
    @team ||= Team.find(params[:id])
  end

  def new
    @team = @season.teams.build(:league_id => params[:league_id])
    add_breadcrumb 'New'
  end

  def edit
  end

  def create
    @team = @season.teams.build params[:team]
    if @team.save
      return_to_last_point :success => 'Team was successfully created.'
    else
      flash[:error] = "Team could not be created."
      load_league_options
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

  def find_team    
    @team = Team.find(params[:id])
    @division = @team.division
    add_breadcrumb @team.league_name
    add_breadcrumb @team.season_name   
    add_breadcrumb @team.name
  end  
  
  def add_teams_breadcrumb
    add_breadcrumb 'Teams', admin_teams_path  
  end

  def find_season
    @season = Season.find(params[:season_id]) if params[:season_id]   
    @season ||= Season.most_recent()
  end
  
  def load_season_links
    @season_links = Season.all.desc(:starts_on).each.collect do |s|
      [s.name, admin_teams_path(:season_id => s.id)]
    end
  end
  
  def load_league_links
    @league_links = @season.leagues.all.asc(:name).each.collect do |s|
      [s.name, admin_teams_path(:season_id => @season.id, :league_id => s.id)]
    end
    @league_links.insert 0, ['All Leagues', admin_teams_path(:season_id => @season.id)]
  end  
  
  def load_league_options
    @leagues = @season.leagues.asc(:name)
  end
  
  def load_division_options
    season = @season
    season ||= @team.season
    @divisions = season.divisions.asc(:name)
  end

  def load_club_options
    @clubs = Club.asc(:name).entries
  end


end

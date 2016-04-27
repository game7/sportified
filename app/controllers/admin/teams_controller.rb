class Admin::TeamsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_teams_breadcrumb
  before_filter :find_season, :only => [:index, :new, :create]
  before_filter :load_season_links, :only => [:index]
  before_filter :load_league_links, :only => [:index]
  before_filter :find_team, :only => [:show, :edit, :update, :destroy]
  before_filter :load_league_options, :only => [:new]
  before_filter :load_club_options, :only => [:new, :edit]

  def index
    @teams = Team.all
    @teams = @teams.for_league(params[:league_id]) if params[:league_id]
    @teams = @teams.for_season(@season) if @season
    @teams = @teams.order(:name)
    @leagues = @season.leagues.order(:name)
    @leagues = @leagues.where(id: params[:league_id]) if params[:league_id]
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
    @team = @season.teams.build(team_params)
    if @team.save
      return_to_last_point :success => 'Team was successfully created.'
    else
      flash[:error] = "Team could not be created."
      load_league_options
      load_club_options
      render :action => "new"
    end
  end

  def update
    if @team.update_attributes(team_params)
      return_to_last_point :success => 'Team was successfully updated.'
    else
      flash[:error] = "Team could not be updated."
      load_club_options
      render :action => "edit"
    end
  end

  def destroy
    @team.destroy
    return_to_last_point :success => 'Team has been deleted.'
  end

  private

  def team_params
    params.required(:team).permit(
      :league_id, :name, :short_name, :club_id, :division_id, :pool, :show_in_standings, :seed,
      :crop_x, :crop_y, :crop_h, :crop_w, :logo, :remote_logo_url, :logo_cache
    )
  end

  def find_team
    @team = Team.find(params[:id])
    add_breadcrumb @team.league.name
    add_breadcrumb @team.season.name
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
    @season_links = Season.all.order(:starts_on => :desc).each.collect do |s|
      [s.name, admin_teams_path(:season_id => s.id)]
    end
  end

  def load_league_links
    @league_links = @season.leagues.all.order(:name).each.collect do |s|
      [s.name, admin_teams_path(:season_id => @season.id, :league_id => s.id)]
    end
    @league_links.insert 0, ['All Leagues', admin_teams_path(:season_id => @season.id)]
  end

  def load_league_options
    @leagues = @season.leagues.order(:name)
  end

  def load_club_options
    @clubs = Club.order(:name).entries
  end


end

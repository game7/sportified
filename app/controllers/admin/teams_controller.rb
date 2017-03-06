class Admin::TeamsController < Admin::BaseLeagueController

  before_action :mark_return_point, :only => [:new, :edit, :destroy]
  before_action :add_teams_breadcrumb
  before_action :find_season, :only => [:index, :new, :create]
  before_action :load_season_links, :only => [:index]
  before_action :load_division_links, :only => [:index]
  before_action :find_team, :only => [:show, :edit, :update, :destroy]
  before_action :load_division_options, :only => [:new]
  before_action :load_club_options, :only => [:new, :edit]

  def index
    @teams = ::League::Team
    @teams = @teams.for_division(params[:division_id]) if params[:division_id]
    @teams = @teams.for_season(@season) if @season
    @teams = @teams.order(:name)
    @divisions = @season.divisions.order(:name)
    @divisions = @divisions.where(id: params[:division_id]) if params[:division_id]

    respond_to do |format|
      format.html
      format.json { render :json => @teams.entries }
    end
  end

  def show
    @team ||= Team.find(params[:id])
  end

  def new
    @team = @season.teams.build(:division_id => params[:division_id], :show_in_standings => true)
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
      load_division_options
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
      :division_id, :name, :short_name, :club_id, :division_id, :pool, :show_in_standings, :seed,
      :crop_x, :crop_y, :crop_h, :crop_w, :logo, :remote_logo_url, :logo_cache
    )
  end

  def find_team
    @team = ::League::Team.find(params[:id])
    add_breadcrumb @team.division.name
    add_breadcrumb @team.season.name
    add_breadcrumb @team.name
  end

  def add_teams_breadcrumb
    add_breadcrumb 'Teams', admin_teams_path
  end

  def find_season
    @season = ::League::Season.find(params[:season_id]) if params[:season_id]
    @season ||= ::League::Season.most_recent()
  end

  def load_season_links
    @season_links = ::League::Season.all.order(:starts_on => :desc).each.collect do |s|
      [s.name, admin_teams_path(:season_id => s.id)]
    end
  end

  def load_division_links
    @division_links = @season.divisions.all.order(:name).each.collect do |s|
      [s.name, admin_teams_path(:season_id => @season.id, :division_id => s.id)]
    end
    @division_links.insert 0, ['All Divisions', admin_teams_path(:season_id => @season.id)]
  end

  def load_division_options
    @divisions = @season.divisions.order(:name)
  end

  def load_club_options
    @clubs = Club.order(:name).entries
  end


end

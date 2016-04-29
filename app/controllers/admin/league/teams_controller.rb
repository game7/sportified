class Admin::League::TeamsController < Admin::BaseLeagueController
  before_filter :find_team, except: [:new, :create]
  before_filter :find_division, only: [:new, :create]
  before_filter :find_program
  before_filter :load_options
  before_filter :add_breadcrumbs, :except => [:destroy]

  def show
    @team = ::League::Team.includes(:division, :season, :program, :players).find(params[:id])
    @games = ::League::Game.for_team(@team)
  end

  def new
    @team = @division.teams.build({season_id: params[:season_id]})
    add_breadcrumb 'New'
  end

  def create
    @team = @division.teams.build(team_params)
    if @team.save
      return_to_last_point :success => 'Team was successfully created.'
    else
      flash[:error] = "Team could not be created."
      render :action => "new"
    end
  end

  def edit

  end

  def update
    if @team.update_attributes(team_params)
      return_to_last_point :success => 'Team was successfully updated.'
    else
      flash[:error] = "Team could not be updated."
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
      :season_id, :division_id, :name, :short_name, :club_id, :division_id, :pool, :show_in_standings, :seed,
      :crop_x, :crop_y, :crop_h, :crop_w, :logo, :remote_logo_url, :logo_cache
    )
  end

  def find_team
    @team = ::League::Team.includes(:division, :season, :program).find(params[:id])
    add_breadcrumb @team.program.name, admin_league_program_path(@team.program)
    add_breadcrumb @team.season.name, admin_league_season_path(@team.season)
    add_breadcrumb @team.division.name
    add_breadcrumb @team.name
  end

  def find_division
    @division = ::League::Division.find(params[:division_id])
  end

  def find_program
    @program = @team ? @team.program : @division.program
  end

  def load_options
    @options = {
      clubs: ::Club.order(:name),
      divisions: @program.divisions.order(:name),
      seasons: @program.seasons.order(:name)
    }
  end

  def add_breadcrumbs

  end

end
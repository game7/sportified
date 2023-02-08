class Admin::League::DivisionsController < Admin::BaseLeagueController
  before_action :mark_return_point, only: %i[new edit destroy]
  before_action :find_league, only: %i[index new create]
  before_action :find_division, only: %i[edit update destroy]
  before_action :add_breadcrumbs, except: [:destroy]

  def index
    @divisions = @league.divisions.order(:name)
    @divisions = @divisions.for_season(params[:season_id]) if params[:season_id]
    respond_to do |format|
      format.html
      format.json { render json: @divisions.entries }
    end
  end

  def new
    @division = ::League::Division.new
  end

  def create
    @division = @league.divisions.build(division_params)
    if @division.save
      return_to_last_point success: 'Division was successfully created.'
    else
      flash[:error] = 'League could not be created'
      render action: :new
    end
  end

  def edit; end

  def update
    if @division.update(division_params)
      return_to_last_point success: 'Division was successfully updated.'
    else
      flash[:error] = 'League could not be updated.'
      render action: :edit
    end
  end

  def destroy
    @division.destroy
    return_to_last_point success: 'Division has been deleted.'
  end

  private

  def division_params
    params.required(:division).permit(:name, :standings_schema_id, :seasons, :show_standings, :show_players,
                                      :show_statistics, season_ids: [])
  end

  def add_breadcrumbs
    league = @league || @division.program
    add_breadcrumb league.name, admin_league_program_path(league)
    add_breadcrumb 'Divisions', admin_league_program_divisions_path(league)
  end

  def find_league
    @league = ::League::Program.find(params[:program_id])
  end

  def find_division
    @division = ::League::Division.find(params[:id])
  end
end

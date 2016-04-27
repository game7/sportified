class Admin::League::SeasonsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :find_league, :only => [:index, :new, :create]
  before_filter :find_season, :only => [:show, :edit, :update, :destroy]
  before_filter :find_seasons, :only => [:index]
  before_filter :get_season_options, :only => [:show]
  before_filter :add_breadcrumbs, :except => [:destroy]

  def index
  end

  def show
    @teams = ::League::Team.joins(:division)
                           .includes(:division)
                           .order('league_divisions.name')
  end

  def new
    @season = @league.seasons.build
  end

  def edit
  end

  def create
    Chronic.time_class = Time.zone
    params[:season][:starts_on] = Chronic.parse(params[:season][:starts_on])
    @season = @league.seasons.build(season_params)
    if @season.save
      return_to_last_point :success => 'Season was successfully created.'
    else
      flash[:error] = "Season could not be created"
      render :action => "new"
    end
  end

  def update
    Chronic.time_class = Time.zone
    params[:season][:starts_on] = Chronic.parse(params[:season][:starts_on])
    if @season.update_attributes(season_params)
      return_to_last_point :success => 'Season was successfully updated.'
    else
      flash[:error] = "Season could not be updated."
      render :action => "edit"
    end
  end

  def destroy
    @season.destroy
    return_to_last_point :success => 'Season has been deleted.'
  end

  private

  def season_params
    params.required(:season).permit(:name, :starts_on, :programs, :division_ids => [])
  end

  def get_season_options
    @season_options = ::League::Season.order(starts_on: :desc).collect{|s| [s.name, admin_league_season_path(s)]}
  end

  def add_breadcrumbs
    league = @league || @season.program
    add_breadcrumb league.name, admin_league_program_path(league)
  end

  def find_league
    @league = ::League::Program.find(params[:program_id])
  end

  def find_season
    @season = ::League::Season.find(params[:id])
  end

  def find_seasons
    @seasons = ::League::Season.order(name: :desc)
  end
end

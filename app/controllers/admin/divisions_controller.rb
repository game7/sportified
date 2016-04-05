class Admin::DivisionsController < Admin::BaseLeagueController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_breadcrumbs
  before_filter :find_division, :only => [:edit, :update, :destroy]

  def index
    @divisions = Division.all.order(:name)
    @divisions = @divisions.for_season(params[:season_id]) if params[:season_id]
    respond_to do |format|
      format.html
      format.json { render :json => @divisions.entries }
    end
  end

  def new
    @division = Division.new
  end

  def create
    @division = Division.new(division_params)
    if @division.save
      return_to_last_point :success => 'Division was successfully created.'
    else
      flash[:error] = "League could not be created"
      find_seasons
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @division.update_attributes(division_params)
      return_to_last_point :success => 'Division was successfully updated.'
    else
      flash[:error] = "League could not be updated."
      find_seasons
      render :action => "edit"
    end
  end

  def destroy
    @division.destroy
    return_to_last_point :success => 'Division has been deleted.'
  end

  private

  def division_params
    params.required(:division).permit(:name, :standings_schema_id, :seasons, :show_standings, :show_players, :show_statistics, :season_ids => [])
  end

  def add_breadcrumbs
    add_breadcrumb 'Divisions', admin_divisions_path
  end

  def find_division
    @division = Division.find(params[:id])
  end

end

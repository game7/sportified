class League::Admin::DivisionsController < League::Admin::BaseLeagueController
  
  before_filter :find_season, :only => [:create, :new]
  before_filter :find_division, :only => [:edit, :update, :destroy]
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]

  def new
    @division = @season.divisions.build
  end

  def edit
  end

  def create
    @division = @season.divisions.build(params[:division])
    if @division.save
      return_to_last_point :success => 'Division was successfully created.'
    else
      flash[:error] = "Division could not be created"
      render :action => "new"
    end
  end

  def update
    if @division.update_attributes(params[:division])
      return_to_last_point :success => 'Division was successfully updated.'
    else
      flash[:error] = "Division could not be updated"
      render :action => "edit"
    end
  end

  def destroy
    @division.destroy
    return_to_last_point :success => 'Division was successfully deleted.'
  end
  
  private

  def find_season
    @season = Season.find(params[:season_id])
    add_breadcrumb @season.name, league_admin_season_path(@season)
  end
  
  def find_division
    @division = Division.find(params[:id]) 
    season = @division.season
    add_breadcrumb season.name, league_admin_season_path(season)
    add_breadcrumb @division.name
  end

  
end

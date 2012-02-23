class Admin::DivisionsController < Admin::BaseLeagueController
  
  before_filter :find_season, :only => [:create, :new]
  before_filter :find_division, :only => [:edit, :update, :destroy]
  before_filter :mark_return_point, :only => [:new, :edit]

  def new
    @division = @season.divisions.build
  end

  def edit

  end

  def create
    @division = @season.divisions.build(params[:division])
    if @division.save
      return_to_last_point(:notice => 'Division was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @division = Division.find(params[:id])
      if @division.update_attributes(params[:division])
        return_to_last_point(:notice => 'Division was successfully updated.')
      else
        load_seasons
        load_standings_layouts
        format.html { render :action => "edit" }
      end
  end

  def destroy
    return_url = admin_season_path(@division.season_id)
    @division.destroy
    respond_to do |format|
      format.html { redirect_to(return_url) }
    end
  end
  
  private

  def find_season
    @season = Season.find(params[:season_id])
    add_breadcrumb @season.name, admin_season_path(@season)
  end
  
  def find_division
    @division = Division.find(params[:id]) 
    season = @division.season
    add_breadcrumb season.name, admin_season_path(season)
    add_breadcrumb @division.name
  end

  
end

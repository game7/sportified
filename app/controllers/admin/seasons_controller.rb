class Admin::SeasonsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_seasons_breadcrumb  
  before_filter :find_season, :only => [:show, :edit, :update, :delete]
  before_filter :find_seasons, :only => [:index]

  def index
  end

  def show
    @divisions = @season.divisions.asc(:name)
  end

  def new
    @season = Season.new
  end

  def edit   
  end

  def create
    @season = Season.new(params[:season])
    if @season.save
      return_to_last_point :success => 'Season was successfully created.'
    else
      flash[:error] = "Season could not be created"
      render :action => "new"
    end
  end

  def update
    if @season.update_attributes(params[:season])
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
  
  def add_seasons_breadcrumb
    add_breadcrumb 'Seasons', admin_seasons_path    
  end

  def find_season
    @season = Season.find(params[:id])
    add_breadcrumb @season.name
  end

  def find_seasons
    @seasons = Season.asc(:name)
  end
end

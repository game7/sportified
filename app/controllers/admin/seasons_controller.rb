class Admin::SeasonsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_seasons_breadcrumb  
  before_filter :find_season, :only => [:edit, :update, :delete]
  before_filter :find_seasons, :only => [:index]
  before_filter :get_season_options, :only => [:show]

  def index
  end
  
  def show
    @season = Season.find(params[:id]) if params[:id]
    @season ||= Season.most_recent
    add_breadcrumb @season.name    
  end

  def new
    @season = Season.new
  end

  def edit   
  end

  def create
    @season = Season.new(season_params)
    if @season.save
      return_to_last_point :success => 'Season was successfully created.'
    else
      flash[:error] = "Season could not be created"
      render :action => "new"
    end
  end

  def update
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
    params.required(:season).permit(:name, :starts_on, :programs)
  end

  def get_season_options
    @season_options = Season.all.desc(:starts_on).collect{|s| [s.name, admin_seasons_path(:id => s == @season ? nil : s.id)]}
  end  
  
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

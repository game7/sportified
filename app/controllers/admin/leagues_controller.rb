class Admin::LeaguesController < Admin::BaseLeagueController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_breadcrumbs
  before_filter :find_league, :only => [:edit, :update, :destroy]
  
  def index
    @leagues = League.all.asc(:name)
  end

  def new
    @league = League.new
  end
  
  def create
    @league = League.new(params[:league])
    if @league.save
      return_to_last_point :success => 'League was successfully created.'
    else
      flash[:error] = "League could not be created"
      find_seasons
      render :action => "new"
    end
  end

  def edit
  end
  
  def update
    if @league.update_attributes(params[:league])
      return_to_last_point :success => 'League was successfully updated.'
    else
      flash[:error] = "League could not be updated."
      find_seasons
      render :action => "edit"
    end
  end
  
  def destroy
    @league.destroy
    return_to_last_point :success => 'League has been deleted.'
  end
  
  private
  
  def add_breadcrumbs
    add_breadcrumb 'Leagues', admin_leagues_path    
  end  
  
  def find_league
    @league = League.find(params[:id])
  end
  
end

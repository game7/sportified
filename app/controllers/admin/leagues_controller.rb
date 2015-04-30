class Admin::LeaguesController < Admin::BaseLeagueController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :add_breadcrumbs
  before_filter :find_league, :only => [:edit, :update, :destroy]
  
  def index
    @leagues = League.all.order(:name)
    @leagues = @leagues.for_season(params[:season_id]) if params[:season_id]
    respond_to do |format|
      format.html
      format.json { render :json => @leagues.entries }
    end    
  end

  def new
    @league = League.new
  end
  
  def create
    @league = League.new(league_params)
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
    if @league.update_attributes(league_params)
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
  
  def league_params
    params.required(:league).permit(:name, :standings_schema_id, :seasons, :show_standings, :show_players, :show_statistics, :league_ids => [])
  end
  
  def add_breadcrumbs
    add_breadcrumb 'Leagues', admin_leagues_path    
  end
  
  def find_league
    @league = League.find(params[:id])
  end
  
end

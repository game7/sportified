class Admin::DivisionsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]

  before_filter :find_season, :only => [:index, :new, :create]
  before_filter :load_season_links, :only => [:index]
  before_filter :load_league_links, :only => [:index]  
  before_filter :load_league_options, :only => [:new, :create]
  before_filter :find_division, :only => [:edit, :update, :destroy]


  def index
    @divisions = Division.all
    @divisions = @divisions.for_league(params[:league_id]) if params[:league_id]  
    @divisions = @divisions.for_season(@season) if @season
    @divisions = @divisions.asc(:name)
    @leagues = @season.leagues.asc(:name)
    @leagues = @leagues.where(:_id => params[:league_id]) if params[:league_id]    
    respond_to do |format|
      format.html
      format.json { render :json => @teams.entries }
    end
  end
  
  def new
    @division = @season.divisions.build(:league_id => params[:league_id])
  end

  def edit
  end

  def create
    @division = @season.divisions.build(division_params)
    if @division.save
      return_to_last_point :success => 'Division was successfully created.'
    else
      flash[:error] = "Division could not be created"
      render :action => "new"
    end
  end

  def update
    if @division.update_attributes(division_params)
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
  
  def division_params
    params.required(:division).permit(:league_id, :name)
  end

  def find_season
    @season = Season.find(params[:season_id]) if params[:season_id]   
    @season ||= Season.most_recent()
  end
  
  def find_division
    @division = Division.find(params[:id]) 
    season = @division.season
    add_breadcrumb season.name, admin_season_path(season)
    add_breadcrumb @division.name
  end
  
  def load_season_links
    @season_links = Season.all.desc(:starts_on).each.collect do |s|
      [s.name, admin_divisions_path(:season_id => s.id)]
    end
  end
  
  def load_league_links
    @league_links = @season.leagues.all.asc(:name).each.collect do |s|
      [s.name, admin_divisions_path(:season_id => @season.id, :league_id => s.id)]
    end
    @league_links.insert 0, ['All Leagues', admin_divisions_path(:season_id => @season.id)]
  end  
  
  def load_league_options
    @leagues = @season.leagues.asc(:name)
  end  

  
end

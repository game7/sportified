class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_games_breadcrumb
  before_filter :load_season_options, :only => [:index, :new, :edit]
  before_filter :load_division_options, :only => [:index]
  before_filter :load_team_options, :only => [:new, :edit]
  before_filter :load_game, :only => [:show, :edit, :destroy]
  before_filter :load_games, :only => [:index]
  before_filter :load_division, :only => [:index]
  before_filter :load_season, :only => [:index]

  def load_division
    @division = Division.for_site(Site.current).find(params[:division_id]) if params[:division_id]
  end

  def load_season
    @season = Season.for_site(Site.current).find(params[:season_id]) if params[:season_id]    
  end

  def load_division_options
    @divisions = Division.for_site(Site.current).asc(:name).entries
  end

  def load_season_options
    @seasons = Season.for_site(Site.current).desc(:starts_on).entries
  end

  def load_team_options
    @teams = Team.for_site(Site.current).asc(:name).entries.collect do |team|
      [ "#{team.name} (#{team.division_name} Division)", team.id ]
    end
  end

  def add_games_breadcrumb
    add_new_breadcrumb 'Games', admin_games_path  
  end

  def load_game
    @game = Game.for_site(Site.current).find(params[:id])        
  end

  def load_games
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 14
    @days_in_past = 7
    @start_date = @date - @days_in_past - 1
    @end_date = @date + @days_in_future + 1
    @next_date = @date + @days_in_future + @days_in_past
    @prev_date = @date - @days_in_future - @days_in_past

    @games = Game.for_site(Site.current)    
    @games = @games.for_division(@division) if @division
    @games = @games.for_season(@season) if @season
    @games = @games.between(@start_date, @end_date) unless @division && @season
    @games = @games.asc(:starts_on)    
  end

  # GET /games
  def index
   
    respond_to do |format|
      format.html
    end
  end

  # GET /games/1
  def show

    respond_to do |format|
      format.html
    end
  end

  # GET /games/new
  def new

    @game = Game.new
    @game.season_id = params[:season_id]

    respond_to do |format|
      format.html
    end
  end

  # GET /games/1/edit
  def edit

  end

  # POST /games
  def create

    @game = Game.new(params[:game])
    @game.site = Site.current
    respond_to do |format|
      if @game.save
        format.html { return_to_last_point(:notice => 'Game was successfully created.') }
      else
        load_season_options
        load_team_options
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { return_to_last_point(:notice => 'Game was successfully updated.') }
      else
        load_season_options
        load_team_options        
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy

    @game.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Game has been deleted.') }
      format.xml  { head :ok }
    end
  end
end
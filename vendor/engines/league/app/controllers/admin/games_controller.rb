class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_games_breadcrumb
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_team_options, :only => [:new, :edit]
  before_filter :load_game, :only => [:show, :edit]

  def add_games_breadcrumb
    add_new_breadcrumb 'Games', admin_games_path  
  end

  def load_season_options
    @seasons = Season.all.desc(:starts_on).entries    
  end

  def load_team_options
    @teams = Team.all.asc(:name).entries.collect do |team|
      [ "#{team.name} (#{team.division_name} Division)", team.id ]
    end
  end

  def load_game

    @game = Game.find(params[:id])
    #@season = @game.season
    #@division = @game.division
#
    #add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    #add_new_breadcrumb @season.name

    #load_area_navigation @division
        
  end

  # GET /games
  def index
    
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 14
    @days_in_past = 7
    @start_date = @date - @days_in_past - 1
    @end_date = @date + @days_in_future + 1
    @next_date = @date + @days_in_future + @days_in_past
    @prev_date = @date - @days_in_future - @days_in_past
    @games = Game.between(@start_date, @end_date).asc(:starts_on)
   
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

    respond_to do |format|
      if @game.save
        format.html { return_to_last_point(:notice => 'Game was successfully created.') }
      else
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
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Game has been deleted.') }
      format.xml  { head :ok }
    end
  end
end

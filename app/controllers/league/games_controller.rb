class League::GamesController < League::BaseDivisionController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :load_for_division, :only => [:new, :index]
  before_filter :load_for_game, :only => [:show, :edit]

  def load_for_division

    if params[:division_id]
      @division = Division.find(params[:division_id])
    else
      @division = Division.with_slug(params[:division_slug]).first
    end

    @season = @division.current_season

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)

    load_area_navigation @division
        
  end

  def load_for_game

    @game = Game.find(params[:id])
    @season = @game.season
    @division = @game.division

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name

    load_area_navigation @division
        
  end

  # GET /games
  # GET /games.xml
  def index

    @teams = @division.teams.for_season(@season).asc(:name).entries
    
    if params[:season_slug]
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @games = @division.games.for_season(@season).asc(:starts_on)
      if params[:team_slug]
        @team = @season.teams.with_slug(params[:team_slug])
        @games = @games.for_team(@team.id)
      end
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 7
      @start_date = @date - @days_in_past - 1
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
      @games = @division.games.between(@start_date, @end_date).asc(:starts_on)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new

    @teams = @division.teams.entries
    @game = @division.games.build
    @game.season_id = @division.seasons.most_current.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @teams = @game.season.teams.entries
  end

  # POST /games
  # POST /games.xml
  def create
    @division = Division.find(params[:division_id])
    @game = @division.games.build(params[:game])

    respond_to do |format|
      if @game.save
        format.html { return_to_last_point(:notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { return_to_last_point(:notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
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

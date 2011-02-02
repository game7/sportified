class League::GamesController < League::BaseSeasonController
  
  before_filter :load_for_season, :only => [:index, :new]
  before_filter :load_for_game, :only => [:show, :edit]

  def load_for_season

    if params[:season_id]
      @season = Season.find(params[:season_id])
      @division = @season.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
    end

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name

    load_area_navigation @division, @season
        
  end

  def load_for_game

    @game = Game.find(params[:id])
    @season = @game.season
    @division = @season.division

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name

    load_area_navigation @division, @season
        
  end

  # GET /games
  # GET /games.xml
  def index

    @games = @season.games.asc(:starts_on)

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

    @teams = @season.teams.entries
    @game = @season.games.build
    @game.left_team = GameTeam.new
    @game.right_team = GameTeam.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @teams = @game.season.teams
  end

  # POST /games
  # POST /games.xml
  def create
    @season = Season.find(params[:season_id])
    @game = @season.games.build(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(league_season_schedule_friendly_path(@game.season.division.slug, @game.season.slug), :notice => 'Game was successfully created.') }
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
        format.html { redirect_to( league_season_schedule_friendly_path(@game.season.division.slug, @game.season.slug), :notice => 'Game was successfully updated.') }
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
      format.html { redirect_to(league_season_games_path(@game.season_id)) }
      format.xml  { head :ok }
    end
  end
end

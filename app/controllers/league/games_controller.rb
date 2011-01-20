class League::GamesController < League::LeagueController
  # GET /games
  # GET /games.xml
  def index
    if params[:season_id]
      @season = Season.find(params[:season_id])
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
      @season ||= @division.seasons.order_by(:starts_on, :desc).last  
    end
    @games = @season.games.asc(:starts_on)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @season = Season.find(params[:season_id])
    @teams = @season.teams
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

class League::PlayersController < League::BaseSeasonController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :load_for_team, :only => [:index, :new]
  before_filter :load_for_player, :only => [:show, :edit]

  def load_for_team
    if params[:team_id]
      @team = Team.find(params[:team_id])
      @season = @team.season
      @division = @season.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @team = @season.teams.with_slug(params[:team_slug]).first
    end

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name, league_season_friendly_path(@division.slug, @season.slug)
    add_new_breadcrumb @team.name

    load_area_navigation @division, @season
  end

  def load_for_player
    
    if params[:id]
      @player = Player.find(params[:id])
      @team = @player.team
      @season = @team.season
      @division = @season.division
    else
      
    end
    
  end

  # GET /players
  # GET /players.xml
  def index

    @players = @team.players.desc(:last_name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @team = Team.find(params[:team_id])
    @player = @team.players.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])    
  end

  # POST /players
  # POST /players.xml
  def create
    @team = Team.find(params[:team_id])
    @player = @team.players.build(params[:player])

    respond_to do |format|
      if @player.save
        format.html { return_to_last_point(:notice => 'Player was successfully created.') }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])
    @team = @player.team

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { return_to_last_point(:notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @team = @player.team
    @player.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Player has been deleted.' ) }
      format.xml  { head :ok }
    end
  end
end

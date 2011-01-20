class League::PlayersController < League::LeagueController
  
  before_filter :determine_division_and_season_and_team, :only => [:index, :show]

  def determine_division_and_season_and_team
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
    @season ||= @division.seasons.order_by(:starts_on, :desc).last    
    @team = @season.teams.with_slug(params[:team_slug]).first if params[:team_slug]
  end

  # GET /players
  # GET /players.xml
  def index
    @team ||= Team.find(params[:team_id])
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
        format.html { redirect_to(league_team_players_path(@team), :notice => 'Player was successfully created.') }
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

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(league_team_players_path(@player.team_id), :notice => 'Player was successfully updated.') }
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
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(league_team_players_url(@player.team_id)) }
      format.xml  { head :ok }
    end
  end
end

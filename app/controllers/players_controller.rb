class PlayersController < BaseDivisionSeasonController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :load_for_team, :only => [:index, :new]
  before_filter :load_for_player, :only => [:show, :edit]

  def load_for_team
    if params[:team_id]
      @team = Team.find(params[:team_id])
      @season = @team.season
      @division = @team.division
    else
      @division = Division.with_slug(params[:division_slug]).first
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @team = @season.teams.with_slug(params[:team_slug]).first
    end

    add_breadcrumb @division.name, division_friendly_path(@division.slug)
    add_breadcrumb @season.name
    add_breadcrumb @team.name

    load_area_navigation @division
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

end

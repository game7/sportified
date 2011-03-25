class Admin::PlayersController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :load_team, :only => [:index, :new]
  before_filter :add_team_breadcrumbs, :only => [:index]

  def load_team
    @team = Team.for_site(Site.current).find(params[:team_id])    
  end

  def add_team_breadcrumbs
    add_breadcrumb @team.division_name
    add_breadcrumb @team.season_name
    add_breadcrumb @team.name
  end

  # GET /players
  # GET /players.xml
  def index

    @players = @team.players.desc(:last_name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @team = Team.find(params[:team_id])
    @player = @team.players.build

    respond_to do |format|
      format.html # new.html.erb
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
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @player = Player.find(params[:id])
    @team = @player.team

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { return_to_last_point(:notice => 'Player was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /players/1
  def destroy
    @player = Player.find(params[:id])
    @team = @player.team
    @player.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Player has been deleted.' ) }
    end
  end
end

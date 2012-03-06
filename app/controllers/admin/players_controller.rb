class Admin::PlayersController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :load_team, :only => [:index, :new]
  before_filter :add_team_breadcrumbs, :only => [:index]

  def index
    @players = @team.players.asc(:last_name)
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @team = Team.find(params[:team_id])
    @player = @team.players.build
  end

  def edit
    @player = Player.find(params[:id])    
  end

  def create
    @team = Team.find(params[:team_id])
    @player = @team.players.build(params[:player])

    if @player.save
      return_to_last_point :success => 'Player was successfully created.'
    else
      render :action => "new"
    end

  end

  def update
    @player = Player.find(params[:id])
    @team = @player.team

    if @player.update_attributes(params[:player])
     return_to_last_point :success => 'Player was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @team = @player.team
    @player.destroy

    return_to_last_point :success => 'Player has been deleted.'
    
  end
  
  private
  
  def load_team
    @team = Team.find(params[:team_id])    
  end

  def add_team_breadcrumbs
    add_breadcrumb @team.league_name
    add_breadcrumb "Teams", admin_teams_path
    add_breadcrumb @team.name
    add_breadcrumb "Roster", admin_team_players_path(@team)
  end  
end

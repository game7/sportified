require 'Chronic'
class Admin::PlayersController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]  
  before_filter :find_player, :only => [:edit, :update, :destroy]
  before_filter :find_team, :only => [:index, :new, :create]
  before_filter :add_team_breadcrumbs, :only => [:index]

  def index
    @players = @team.players.asc(:last_name)
  end

  def new
    @player = @team.players.build
  end

  def edit 
  end

  def create
    params[:player][:birthdate] = Chronic.parse params[:player][:birthdate]
    @player = @team.players.build(params[:player])
    if @player.save
      return_to_last_point :success => 'Player was successfully created.'
    else
      render :action => "new"
    end

  end

  def update
    params[:player][:birthdate] = Chronic.parse params[:player][:birthdate]    
    if @player.update_attributes(params[:player])
     return_to_last_point :success => 'Player was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @player.destroy
    return_to_last_point :success => 'Player has been deleted.'
  end
  
  private
  
  def find_player
    @player = Player.find(params[:id])
  end
  
  def find_team
    @team = Team.find(params[:team_id])    
  end

  def add_team_breadcrumbs
    add_breadcrumb @team.league_name
    add_breadcrumb "Teams", admin_teams_path
    add_breadcrumb @team.name
    add_breadcrumb "Roster", admin_team_players_path(@team)
  end  
end

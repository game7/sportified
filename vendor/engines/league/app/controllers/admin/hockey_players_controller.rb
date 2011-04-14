class Admin::HockeyPlayersController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :load_player, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides

  def load_statsheet
    @statsheet = HockeyStatsheet.find(params['hockey_statsheet_id'])
  end

  def load_player
    @player = @statsheet.players.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.left_team_name, 'left'], [@statsheet.right_team_name, 'right'] ]    
  end
  
  def new
    @player = HockeyPlayer.new
  end

  def edit
  end

  def update
    @player.update_attributes(params['hockey_player'])
    if @player.save
      flash[:notice] = "Player Updated"
    end
  end

  def create
    @player = @statsheet.players.build(params['hockey_player'])
    if @player.save
      @statsheet.reload
      flash[:notice] = "Player Added"
    end    
  end

  def destroy
    
    if @players.delete 
      flash[:notice] = "Player has been deleted"
    end

  end

  def reload
    @statsheet.reload_players
    if @statsheet.save
      flash[:notice] = "Players have been reloaded from team rosters"
    end
  end

end

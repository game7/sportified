class Admin::HockeyPlayersController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  before_filter :load_player, :only => [:edit, :update, :destroy]
  def load_player
    @player = @statsheet.players.find(params['id'])
  end

  before_filter :prepare_sides
  def prepare_sides
    @sides = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end

  
  def new
    @player = Hockey::Player.new
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

  def load
    @statsheet.reload_players
    if @statsheet.save
      flash[:notice] = "Players have been loaded from team rosters"
    end    
  end
  def reload
    @statsheet.reload_players
    if @statsheet.save
      flash[:notice] = "Players have been reloaded from team rosters"
    end
  end

end

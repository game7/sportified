class Admin::HockeyPlayersController < Admin::BaseLeagueController  
  before_filter :load_statsheet
  before_filter :load_player, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides, :only => [:new, :create]

  def new
    @player = @statsheet.players.build(:played => true)
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
    
    if @player.delete 
      flash[:success] = "Player has been deleted"
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
  
  private
  
  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def load_player
    @player = @statsheet.players.find(params['id'])
  end

  def prepare_sides
    @side_options = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end  

end

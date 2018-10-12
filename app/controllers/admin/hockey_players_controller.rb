class Admin::HockeyPlayersController < Admin::BaseLeagueController
  before_action :load_statsheet
  before_action :load_player, :only => [:edit, :update, :destroy]
  before_action :prepare_team_options, :only => [:new, :create]

  def new
    @player = @statsheet.skaters.build(:games_played => true)
  end

  def edit
  end

  def update
    @player.update_attributes(hockey_player_params)
    if @player.save
      flash[:notice] = "Player Updated"
    end
  end

  def create
    @player = @statsheet.skaters.build(hockey_player_params)
    byebug
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
    @statsheet.load_players
    if @statsheet.save
      flash[:notice] = "Players have been loaded from team rosters"
    end
  end

  private

  def hockey_player_params
    params.required(:hockey_skater_result).permit(:games_played, :first_name, :last_name, :jersey_number, :team_id)
  end

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def load_player
    @player = @statsheet.skaters.find(params['id'])
  end

  def prepare_team_options
    @team_options = [ [@statsheet.away_team.name, @statsheet.away_team.id], [@statsheet.home_team.name, @statsheet.home_team.id] ]
  end

end

class Admin::HockeyPlayersController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations
  before_action :load_statsheet
  before_action :load_player, only: %i[edit update destroy]
  before_action :prepare_team_options, only: %i[new create]

  def new
    @player = @statsheet.skaters.build(games_played: true)
  end

  def edit; end

  def update
    if @player.update(hockey_player_params)
      respond_to do |format|
        format.html { flash[:success] = 'Player Updated' }
        format.json { render json: @player }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @player = @statsheet.skaters.build(hockey_player_params)
    if @player.save
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = 'Player Added'
        end
        format.json { render json: @player }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    return unless @player.delete

    respond_to do |format|
      format.html { flash[:notice] = 'Player has been deleted' }
      format.json { head :no_content }
    end
  end

  def load
    @statsheet.load_players
    return unless @statsheet.save

    respond_to do |format|
      format.html { flash[:notice] = 'Players have been loaded from team rosters' }
      format.json { render json: @statsheet.skaters }
    end
  end

  private

  def serialize_errors(resource)
    resource.errors # .to_h.deep_transform_keys{|k| k.to_s.camelize(:lower) }
  end

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
    @team_options = [[@statsheet.away_team.name, @statsheet.away_team.id],
                     [@statsheet.home_team.name, @statsheet.home_team.id]]
  end
end

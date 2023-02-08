class Admin::HockeyPenaltiesController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations
  before_action :load_statsheet
  before_action :load_penalty, only: %i[edit update destroy]
  before_action :list_players, only: %i[new edit]

  def new
    @penalty = Hockey::Penalty.new
  end

  def edit; end

  def create
    penalty_service = Hockey::PenaltyService.new(@statsheet)
    @penalty = penalty_service.create_penalty!(hockey_penalty_params)
    if @penalty.persisted?
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = 'Penalty Added'
        end
        format.json { render json: @penalty }
      end
    else
      respond_to do |format|
        format.html do
          list_players
        end
        format.json { render json: @penalty.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @penalty.update(hockey_penalty_params)
      flash[:notice] = 'Penalty Updated'
      respond_to do |format|
        format.html { flash[:notice] = 'Penalty Updated' }
        format.json { render json: @penalty }
      end
    else
      format.html { list_players }
      format.json { render json: @penalty.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    penalty_service = Hockey::PenaltyService.new(@statsheet)
    @penalty = penalty_service.destroy_penalty!(params[:id])
    return unless @penalty.destroyed?

    @statsheet.save
    respond_to do |format|
      format.html { flash[:notice] = 'Penalty has been deleted' }
      format.json { head :no_content }
    end
  end

  private

  def hockey_penalty_params
    params.required(:hockey_penalty).permit(:period, :minute, :second, :team_id, :committed_by_id,
                                            :infraction, :duration, :severity,
                                            :start_period, :start_minute, :start_second,
                                            :end_period, :end_minute, :end_second)
  end

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def load_penalty
    @penalty = @statsheet.penalties.find(params['id'])
  end

  def list_players
    @players = @statsheet.skaters.playing.order(last_name: :asc)
  end
end

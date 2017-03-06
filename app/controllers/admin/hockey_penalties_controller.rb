class Admin::HockeyPenaltiesController < Admin::BaseLeagueController

  before_action :load_statsheet
  before_action :load_penalty, :only => [:edit, :update, :destroy]
  before_action :list_players, :only => [:new, :edit]

  def new
    @penalty = Hockey::Penalty.new
  end

  def edit

  end

  def create
    penalty_service = Hockey::PenaltyService.new(@statsheet)
    @penalty = penalty_service.create_penalty!(hockey_penalty_params)
    if @penalty.persisted?
      @statsheet.reload
      flash[:notice] = "Penalty Added"
    else
      list_players
    end
  end

  def update
    @penalty.update_attributes(hockey_penalty_params)
    if @penalty.save
      flash[:notice] = "Penalty Updated"
    else
      list_players
    end
  end

  def destroy
    flash[:notice] = "Penalty has been deleted" if @penalty.delete
  end

  def destroy
    penalty_service = Hockey::PenaltyService.new(@statsheet)
    @penalty = penalty_service.destroy_penalty!(params[:id])
    if @penalty.destroyed?
      @statsheet.save
      flash[:notice] = "Penalty has been deleted"
    end

  end

  private

  def hockey_penalty_params
    params.required(:hockey_penalty).permit(:period, :minute, :second, :team_id, :committed_by_id,
      :infraction, :duration, :severity,
      :start_period, :start_minute, :start_second,
      :end_period, :end_minute, :end_second
    )
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

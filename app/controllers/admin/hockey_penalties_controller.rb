class Admin::HockeyPenaltiesController < Admin::BaseLeagueController

  before_filter :load_statsheet
  before_filter :load_penalty, :only => [:edit, :update, :destroy]
  before_filter :list_players, :only => [:new, :edit]

  def new
    @penalty = Hockey::Penalty.new
  end

  def edit

  end

  def create
    @penalty = @statsheet.penalties.build(hockey_penalty_params)
    if @statsheet.save
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

class Hockey::PenaltyService

  def initialize(statsheet)
    @statsheet = statsheet
  end

  def create_penalty!(params)
    @statsheet.transaction do
      @penalty = @statsheet.penalties.build(params)
      @penalty.save!
      update_player_results!(@penalty, 1)
    end
    @penalty
  end

  def update_player_results!(penalty, factor)
    increment_statistics!(penalty, factor)
  end

  def destroy_penalty!(id)
    @statsheet.transaction do
      @penalty = @statsheet.penalties.find(id)
      update_player_results!(@penalty, -1)
      @penalty.destroy
    end
    @penalty
  end

  private

  def increment_statistics!(penalty, factor)
    penalty.committed_by.penalties                 += factor
    penalty.committed_by.penalty_minutes           += penalty.duration * factor
    penalty.committed_by.minor_penalties           += factor if penalty.severity == 'Minor'
    penalty.committed_by.major_penalties           += factor if penalty.severity == 'Major'
    penalty.committed_by.misconduct_penalties      += factor if penalty.severity == 'Misconduct'
    penalty.committed_by.game_misconduct_penalties += factor if penalty.severity == 'Game misconduct'
    penalty.committed_by.save!
  end

end

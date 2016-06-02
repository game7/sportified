class Hockey::GoalService

  def initialize(statsheet)
    @statsheet = statsheet
  end

  def create_goal!(params)
    @statsheet.transaction do
      @goal = @statsheet.goals.build(params)
      @goal.save!
      update_player_results!(@goal, 1)
    end
    @goal
  end

  def destroy_goal!(id)
    @statsheet.transaction do
      @goal = @statsheet.goals.find(id)
      update_player_results!(@goal, -1)
      @goal.destroy
    end
    @goal
  end

  def update_player_results!(goal, factor)
      increment_goals!(goal.scored_by, factor)
      increment_assists!(goal.assisted_by, factor)
      increment_assists!(goal.also_assisted_by, factor)
  end

  private

  def increment_goals!(scored_by, amount)
    return unless scored_by
    scored_by.goals += amount
    scored_by.save!
  end

  def increment_assists!(assisted_by, amount)
    return unless assisted_by
    assisted_by.assists += amount
    assisted_by.save!
  end

end

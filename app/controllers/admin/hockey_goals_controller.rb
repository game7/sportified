class Admin::HockeyGoalsController < Admin::BaseLeagueController

  before_filter :load_statsheet
  before_filter :list_players, :only => [:new, :edit]

  def new
    @goal = Hockey::Goal.new{|goal| goal.strength = '5-5' }
  end

  def create
    @goal = @statsheet.goals.build(hockey_goal_params)
    if @statsheet.save
      @statsheet.reload
      flash[:notice] = "Goal Added"
    else
      list_players
    end
  end

  def destroy

    goal = @statsheet.goals.find(params['id'])
    if goal.delete
      @statsheet.save
      flash[:notice] = "Goal has been deleted"
    end

  end

  private

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.game.away_team_id, @statsheet.game.away_team.name], [@statsheet.game.home_team_id, @statsheet.game.home_team.name] ]
  end

  def hockey_goal_params
    params.required(:hockey_goal).permit(:team_id, :period, :minute, :second, :scored_by_id, :assisted_by_id, :also_assisted_by_id, :strength)
  end

  def list_players
    @players = @statsheet.skaters.playing.order(last_name: :asc)
  end

end

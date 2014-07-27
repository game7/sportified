class Admin::HockeyGoalsController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :prepare_sides

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end
  
  def new
    @goal = Hockey::Goal.new
  end

  def create
    @goal = @statsheet.events.build(hockey_goal_params, Hockey::Goal)
    if @statsheet.save
      @statsheet.reload
      flash[:notice] = "Goal Added"
    end    
  end

  def destroy
    
    goal = @statsheet.events.goals.find(params['id'])
    if goal.delete 
      @statsheet.save
      flash[:notice] = "Goal has been deleted"
    end

  end
  
  private
  
  def hockey_goal_params
    params.required(:hockey_goal).permit(:side, :per, :min, :sec, :side, :plr, :a1, :a2, :str)
  end

end

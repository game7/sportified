class League::Admin::HockeyGoalsController < League::Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :prepare_sides

  def load_statsheet
    @statsheet = HockeyStatsheet.find(params['hockey_statsheet_id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.left_team_name, 'left'], [@statsheet.right_team_name, 'right'] ]    
  end
  
  def new
    @goal = HockeyGoal.new
  end

  def create
    @goal = @statsheet.events.build(params['hockey_goal'], HockeyGoal)
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

end

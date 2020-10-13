class Admin::HockeyGoalsController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations 
  before_action :load_statsheet
  before_action :list_players, :only => [:new, :edit]

  def new
    @goal = Hockey::Goal.new{|goal| goal.strength = '5-5' }
  end

  def create

    goal_service = Hockey::GoalService.new(@statsheet)
    @goal = goal_service.create_goal!(hockey_goal_params)
    if @goal.persisted?
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = "Goal Added"
        end
        format.json  { render json: @goal }
      end
    else
      respond_to do |format|
        format.html do
          list_players
        end 
        format.json  { render json: @goal.errors, status: 422 }
      end  
    end
  end

  def destroy
    goal_service = Hockey::GoalService.new(@statsheet)
    @goal = goal_service.destroy_goal!(params[:id])
    if @goal.destroyed?
      @statsheet.save
      respond_to do |format|
        format.html { flash[:notice] = "Goal Deleted" }
        format.json { head :no_content }
      end
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
    params.required(:hockey_goal).permit(:team, :team_id, :period, :minute, :second, :scored_by_id, :assisted_by_id, :also_assisted_by_id, :strength)
  end

  def list_players
    @players = @statsheet.skaters.playing.order(last_name: :asc)
  end

end

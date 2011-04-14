class Admin::HockeyPenaltiesController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :load_penalty, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides
  before_filter :load_infractions

  def load_statsheet
    @statsheet = HockeyStatsheet.find(params['hockey_statsheet_id'])
  end

  def load_penalty
    @penalty = @statsheet.events.penalties.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.left_team_name, 'left'], [@statsheet.right_team_name, 'right'] ]    
  end

  def load_infractions
    @infractions = HockeyPenalty.infractions.collect{|i| i.humanize}
  end
  
  def new
    @penalty = HockeyPenalty.new
  end

  def edit

  end

  def create
    @penalty = @statsheet.events.build(params['hockey_penalty'], HockeyPenalty)
    if @statsheet.save
      @statsheet.reload
      flash[:notice] = "Penalty Added"
    end    
  end
  
  def update
    @penalty.update_attributes(params['hockey_penalty'])
    if @penalty.save
      flash[:notice] = "Penalty Updated"
    end
  end

  def destroy
    
    if @penalty.delete 
      flash[:notice] = "Penalty has been deleted"
    end

  end

end

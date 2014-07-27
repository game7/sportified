class Admin::HockeyPenaltiesController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :load_penalty, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides
  
  def new
    @penalty = Hockey::Penalty.new
  end

  def edit

  end

  def create
    @penalty = @statsheet.events.build(hockey_penalty_params, Hockey::Penalty)
    if @statsheet.save
      @statsheet.reload
      flash[:notice] = "Penalty Added"
    end    
  end
  
  def update
    @penalty.update_attributes(hockey_penalty_params)
    if @penalty.save
      flash[:notice] = "Penalty Updated"
    end
  end

  def destroy
    flash[:notice] = "Penalty has been deleted" if @penalty.delete
  end
  
  private
  
  def hockey_penalty_params
    params.required(:hockey_penalty).permit(:side, :per, :min, :sec, :side, :plr, :inf, :dur, :severity,
      :start_per, :start_min, :start_sec,
      :end_per, :end_min, :end_sec
    ) 
  end

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def load_penalty
    @penalty = @statsheet.events.penalties.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end

end

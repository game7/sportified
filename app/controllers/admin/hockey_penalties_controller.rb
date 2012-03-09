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
    @penalty = @statsheet.events.build(params['hockey_penalty'], Hockey::Penalty)
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
    flash[:notice] = "Penalty has been deleted" if @penalty.delete
  end
  
  private

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

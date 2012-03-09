class Admin::HockeyGoaltendersController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :load_goaltender, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def load_goaltender
    @goaltender = @statsheet.goaltenders.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end
  
  def new
    @goaltender = Hockey::Goaltender.new
  end

  def edit
  end

  def update
    @goaltender.update_attributes(params['hockey_goaltender'])
    if @goaltender.save
      flash[:notice] = "Goaltender Updated"
    end
  end

  def create
    @goaltender = @statsheet.goaltenders.build(params['hockey_goaltender'])
    if @goaltender.save
      @statsheet.reload
      flash[:notice] = "Goaltender Added"
    end    
  end

  def destroy
    flash[:notice] = "Goaltender has been deleted" if @goaltender.delete 
  end

end

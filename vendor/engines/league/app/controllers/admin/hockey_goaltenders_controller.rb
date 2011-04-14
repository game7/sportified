class Admin::HockeyGoaltendersController < Admin::BaseLeagueController
  
  before_filter :load_statsheet
  before_filter :load_goaltender, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides

  def load_statsheet
    @statsheet = HockeyStatsheet.find(params['hockey_statsheet_id'])
  end

  def load_goaltender
    @goaltender = @statsheet.goaltenders.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.left_team_name, 'left'], [@statsheet.right_team_name, 'right'] ]    
  end
  
  def new
    @goaltender = HockeyGoaltender.new
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
    
    if @goaltender.delete 
      flash[:notice] = "Goaltender has been deleted"
    end

  end

end

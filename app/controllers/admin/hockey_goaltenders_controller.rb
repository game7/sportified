class Admin::HockeyGoaltendersController < Admin::BaseLeagueController
  
  before_filter :find_statsheet
  before_filter :find_goaltender, :only => [:edit, :update, :destroy]
  before_filter :prepare_sides
  
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
  
  def autoload
    @statsheet.goaltenders.all.each{|g|g.delete}
    @statsheet.autoload_goaltenders
    if @statsheet.save
      @statsheet.reload
      flash[:success] = "Goaltenders Loaded."
    else
      flash[:error] = "Goaltenders could not be loaded."
    end
  end
  
  private
  
  def find_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def find_goaltender
    @goaltender = @statsheet.goaltenders.find(params['id'])
  end

  def prepare_sides
    @sides = [ [@statsheet.away_team_name, 'away'], [@statsheet.home_team_name, 'home'] ]    
  end  

end

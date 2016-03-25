class Admin::HockeyGoaltendersController < Admin::BaseLeagueController

  before_filter :find_statsheet
  before_filter :find_goaltender, :only => [:edit, :update, :destroy]
  before_filter :list_players, :only => [:new, :edit]

  def new
    @goaltender = @statsheet.goaltenders.build()
  end

  def edit
  end

  def update
    @goaltender.update_attributes(hockey_goaltender_params)
    if @goaltender.save
      flash[:notice] = "Goaltender Updated"
    else
      list_players
    end
  end

  def create
    @goaltender = @statsheet.goaltenders.build(hockey_goaltender_params)
    if @goaltender.save
      @statsheet.reload
      flash[:notice] = "Goaltender Added"
    else
      list_players
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

  def hockey_goaltender_params
    params.required(:hockey_goaltender_result).permit(:team_id, :player_id, :minutes_played, :shots_against, :goals_against)
  end

  def find_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def find_goaltender
    @goaltender = @statsheet.goaltenders.find(params['id'])
  end

  def list_players
    @players = @statsheet.skaters.playing.order(last_name: :asc)
  end


end

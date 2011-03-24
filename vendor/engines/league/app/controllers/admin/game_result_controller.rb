class Admin::GameResultController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :destroy]
  before_filter :load_game
  before_filter :get_season

  def load_game
    @game = Game.for_site(Site.current).find(params[:game_id])    
  end
  
  def get_season
    @season = @game.season    
  end

  def new
    @game.build_result
  end

  def create
    @game.build_result(params[:game_result])

    respond_to do |format|
      if @game.result.save
        format.html { return_to_last_point(:notice => 'Game Result has been successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end    
  end

  def destroy
    @game.result.destroy
    @game.save

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Game Result has been deleted.') }
    end    
  end

end

class Admin::GameResultController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :destroy]

  def new
    @game = Game.find(params[:game_id])
    @season = @game.season
    @game.build_result

  end

  def create
    @game = Game.find(params[:game_id])
    @game.build_result(params[:game_result])
    @season = @game.season

    respond_to do |format|
      if @game.result.save
        format.html { return_to_last_point(:notice => 'Game Result has been successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end    
  end

  def destroy
    @game = Game.find(params[:game_id])
    @game.result.destroy
    @game.save
    @season = @game.season

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Game Result has been deleted.') }
    end    
  end

end

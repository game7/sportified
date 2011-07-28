class Admin::GameResultsController < Admin::BaseLeagueController
  
  before_filter :load_game_result, :only => [:edit, :update]
  def load_game_result  
    @result = GameResult.find(params[:id])
  end

  def index
    @games = Game.all
    @games = @games.in_the_past.without_final_result
    @games = @games.desc(:starts_on)
  end

  def edit
  
  end

  def update
    if @result.update_attributes(params[:game_result])
      flash[:notice] = 'Game Result has been updated.'
    end  
  end

end

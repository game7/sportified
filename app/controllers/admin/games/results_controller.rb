class Admin::Games::ResultsController < Admin::BaseLeagueController
  
  before_filter :find_game, :only => [:new, :create, :destroy]

  def new
    @result = @game.build_result
  end

  def create
    @result = @game.build_result(params[:game_result])
    if @game.save
      flash[:success] = "Game Result has been posted."
    else
      flash[:error] = "Game Result could not be posted."
    end  
  end
  
  private
  
  def find_game
    @game = Game.find(params[:game_id])
  end

end

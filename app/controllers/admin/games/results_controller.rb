class Admin::Games::ResultsController < Admin::BaseLeagueController
  
  before_filter :find_game, :only => [:new, :create, :destroy]

  def new
    current = @game.result.clone if @game.result
    @result = @game.build_result
    if current
      puts @result.home_score = current.home_score
      puts @result.away_score = current.away_score
      puts @result.completed_in = current.completed_in
    end 
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

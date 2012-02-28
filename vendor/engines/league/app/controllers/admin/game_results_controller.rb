class Admin::GameResultsController < Admin::BaseLeagueController
  
  before_filter :add_game_results_breadcrumb
  before_filter :find_game, :only => [:new, :create, :destroy]

  def index
    @games = Game.all
    @games = @games.in_the_past.without_result
    @games = @games.desc(:starts_on)
  end

  def new
    @game_result = @game.build_result
  end

  def create
    @game_result = @game.build_result(params[:game_result])
    if @game_result.save
      flash[:success] = "Game Result has been posted."
    else
      flash[:error] = "Game Result could not be posted."
    end  
  end
  
  private

  def add_game_results_breadcrumb
    add_breadcrumb 'Game Results', admin_game_results_path
  end
  
  def find_game
    @game = Game.find(params[:game_id])
  end

end

class Admin::GameResultsController < Admin::BaseLeagueController
  
  before_filter :add_game_results_breadcrumb
  def add_game_results_breadcrumb
    add_breadcrumb 'Game Results', admin_game_results_path
  end

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

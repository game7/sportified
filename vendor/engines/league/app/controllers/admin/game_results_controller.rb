class Admin::GameResultsController < Admin::BaseLeagueController
  
  before_filter do |c| # Load GameResult
    @result = GameResult.find(params[:id])
  end

  def edit
  
  end

  def update
    if @result.update_attributes(params[:game_result])
      flash[:notice] = 'Game Result has been updated.'
    end  
  end

end

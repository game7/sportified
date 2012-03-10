class GamesController < BaseLeagueController

  before_filter :load_game, :only => [:box_score]
  
  def load_game
    @game = Game.find(params[:id])
  end


  def box_score
    @stats = @game.statsheet
    @left_team = @game.left_team
    @right_team = @game.right_team
  end

end

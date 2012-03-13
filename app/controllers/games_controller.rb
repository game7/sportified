class GamesController < BaseLeagueController
  before_filter :find_game, :only => [:box_score]

  def box_score
    @stats = @game.statsheet
    @home_team = @game.home_team
    @away_team = @game.away_team
  end
  
  private
  
  def find_game
    @game = Game.find(params[:id])
  end

end

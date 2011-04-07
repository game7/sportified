class League::GamesController < League::BaseDivisionSeasonController

  before_filter :load_game, :only => [:box_score]
  
  def load_game
    @game = Game.find(params[:id])
  end


  def box_score
    @stats = @game.statsheet
  end

end

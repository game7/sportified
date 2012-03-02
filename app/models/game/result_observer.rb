class Game::ResultObserver < Mongoid::Observer
  
  def after_create(result)
    game = result.game
    Team::Record::Processor.post_game!(game)
    #processor.update_power_rankings_from_game(game)    
  end
  
end

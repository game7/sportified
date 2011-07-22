class GameManager
  extend MessageHandler

  on :venue_renamed do |message|
    games = Game.where(:venue_id => message.data[:venue_id])
    games.all.each do |game|
      game.venue_name = message.data[:new_venue_name]
      game.venue_short_name = message.data[:new_venue_short_name]
      game.save
    end
  end

end

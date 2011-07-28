
namespace :league do
  
  desc "Set duration"
  task :set_game_duration => :environment do
    Game.all.each do |game|
      game.duration = 75
      game.save
    end
  end

  desc "Convert all events to type = Game"
  task :set_events_to_game => :environment do
    Event.all.each do |e|
      e[_type] = "Game"
      e.save
    end
  end

end

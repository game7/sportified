
namespace :league do
  
  desc "Set duration"
  task :set_game_duration => :environment do
    Game.all.each do |game|
      game.duration = 75
      game.save
    end
  end

end

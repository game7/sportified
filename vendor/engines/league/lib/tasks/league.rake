
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
      e["_type"] = "Game"
      e.save
    end
  end

  desc "Recalculate all team records"
  task :recalculate_team_records => :environment do
    manager = TeamRecordManager.new
    Season.all.each do |season|
      Division.all.each do |division|
        manager.recalculate(division.id, season.id)
      end
    end
  end

  desc "Drop all Games"
  task :destroy_all_games => :environment do
    Game.all.each{|g| g.delete}
  end

end

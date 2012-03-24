
namespace :league do
  
  desc "Update hockey statsheet player names"
  task :update_statsheet_player_names => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      puts "TENANT = #{tenant.host}"
      Game.all.includes(:statsheet).each do |game|
        puts "NEXT GAME..."
        if game.has_statsheet?
          puts "-- HAS STATSHEET"
          game.statsheet.players.includes(:player).each do |p|
            if p.player
              p.first_name = p.player.first_name
              p.last_name = p.player.last_name
              puts "---- UPDATING #{p.last_name}, #{p.first_name}"
            end
          end
          puts "-- ABOUT TO SAVE"
          game.statsheet.save
          puts " -- SAVED!"
        end
      end
    end
  end
  
  desc "Update all player stats"
  task :update_all_statistics => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      puts "TENANT = #{tenant.host}"
      Game.all.includes(:statsheet).each do |game|
        puts "NEXT GAME: #{game.summary} (#{game.starts_on.strftime('%m/%d/%y')})"
        if game.has_statsheet?
          puts "-- HAS STATSHEET"
          unless game.statsheet.posted?
            puts "---- IT'S POSTED"
            puts "---- UNPOSTING..."
            Hockey::Statsheet::Processor.unpost game.statsheet
            puts "---- DONE UNPOSTING"
            puts "---- RE-POSTING..."
            Hockey::Statsheet::Processor.post @statsheet
            puts "---- DONE RE-POSTING"
          end
        end
      end
    end
  end  


end

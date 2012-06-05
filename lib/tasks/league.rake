
namespace :league do
  
  desc "Restore matchups from team records"
  task :restore_matchups => :environment do
    Tenant.all.each do |tenant|
      save = ENV["SAVE"] || false
      Tenant.current = tenant
      puts "TENANT = #{tenant.host}"
      Team.all.each do |team|
        puts "  TEAM = #{team.name} (#{team.league_name} - #{team.season_name})"
        team.record.results.each do |result|
          dirty = false
          game = result.game
          if game.result.home_score == result.scored and game.home_team_id != team.id
            game.home_team_id = team.id
            puts "    -- assigning team to home team (was #{game.home_team_name})"
            dirty = true
          elsif game.result.away_score == result.scored and game.away_team_id != team.id
            game.away_team_id = team.id
            puts "    -- assigning team to away team (was #{game.away_team_name})"            
            dirty = true
          end
          if game.result.home_score == result.allowed and game.home_team_id != result.opponent_id
            game.home_team_id = result.opponent_id
            puts "    -- assigning opponent to home team (was #{game.home_team_name})"            
            dirty = true
          elsif game.result.away_score == result.allowed and game.away_team_id != result.opponent_id
            game.away_team_id = result.opponent_id
            puts "    -- assigning opponent to away team (was #{game.away_team_name})"            
            dirty = true
          end
          if dirty
            puts "    ABOUT TO SAVE [#{game.summary}]"
            game.save if save
            puts "    SAVED" if save
          end
        end
      end
    end
  end
  
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
      Game.all.each do |game|
        puts "NEXT GAME: #{game.summary} (#{game.starts_on.strftime('%m/%d/%y')})"
        statsheet = game.statsheet
        if statsheet
          puts "-- HAS STATSHEET"
          unless statsheet.posted?
            puts "---- IT'S POSTED"
            puts "---- UNPOSTING..."
            Hockey::Statsheet::Processor.unpost statsheet
            puts "---- DONE UNPOSTING"
            puts "---- RE-POSTING..."
            Hockey::Statsheet::Processor.post statsheet
            puts "---- DONE RE-POSTING"
          end
        end
      end
    end
  end  


end

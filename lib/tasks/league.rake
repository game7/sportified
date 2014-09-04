
namespace :league do
  
  desc "Restore matchups from team records"
  task :restore_matchups => :environment do
    Tenant.all.each do |tenant|
      save = ENV["SAVE"] || false
      Tenant.current = tenant
      puts "TENANT = #{tenant.host}"
      Team.all.each do |team|
        puts ""
        puts "  TEAM = #{team.name} (#{team.league_name} - #{team.season_name})"
        if team.season_name == '2012 Summer'
          puts "  -> SKIP"
          next
        end
        team.record.results.each do |result|
          dirty = false
          game = result.game
          puts "  -> Result for game on #{result.played_on.to_s} vs. #{result.opponent_name} [#{game.summary}]"
          puts "  -> #{game.away_team_id} @ #{game.home_team_id}"
          opponent = Team.for_league(team.league_id).for_season(team.season_id).where(:name => result.opponent_name).first
          unless opponent
            puts "    RUH-ROH - opposing team could not be found!!!!!"
            next
          end          
          if game.result.home_score == result.scored
            puts "    -- #{team.name} should be the HOME team (#{game.home_team_id} == #{team.id})"
            unless game.home_team_id == team.id
              puts "    --- but they are not so let's SET HOME TEAM to #{team.name}"
              puts "    --- #{game.home_team_id} set to #{team.id}"
              game.home_team_id = team.id
              dirty = true
            end
            puts "    -- #{opponent.name} should be the AWAY team (#{game.away_team_id} == #{opponent.id})"
            unless game.away_team_id == opponent.id
              puts "    --- but they are not so let's SET AWAY TEAM to #{opponent.name}"
              puts "    --- #{game.away_team_id} set to #{opponent.id}"
              game.away_team_id = opponent.id
              dirty = true              
            end
          elsif game.result.away_score == result.scored
            puts "    -- #{team.name} should be the AWAY team (#{game.away_team_id} == #{team.id})"
            unless game.away_team_id == team.id
              puts "    --- but they are not so let's SET AWAY TEAM to #{team.name}"
              puts "    --- #{game.away_team_id} set to #{team.id}"
              game.away_team_id = team.id
              dirty = true
            end
            puts "    -- #{opponent.name} should be the HOME team (#{game.home_team_id} == #{opponent.id})"
            unless game.home_team_id == opponent.id
              puts "    --- but they are not so let's SET HOME TEAM to #{opponent.name}"
              puts "    --- #{game.home_team_id} set to #{opponent.id}"
              game.home_team_id = opponent.id
              dirty = true              
            end            
          else
            "    -- RUH-ROH... this result doesn't match the game..."
          end
          if dirty
            puts "  -> this bitch is diry and should be saved [#{game.summary}]"
            puts "  -> #{game.away_team_id} @ #{game.home_team_id}"
            game.save if save
            puts "  -> SAVED AS [#{game.summary}]" if save
            puts "  -> #{game.away_team_id} @ #{game.home_team_id}" if save
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
      season = Season.where(:name => '2014 Summer').first
      Game.for_season(season).each do |game|
        puts "NEXT GAME: #{game.summary} (#{game.starts_on.strftime('%m/%d/%y')})"
        statsheet = game.statsheet
        if statsheet
          puts "-- HAS STATSHEET"
          if statsheet.posted?
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
  
  desc "Brandify teams"
  task :brandify_teams => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      #iterate teams with branding
      Team.where(:logo.ne => nil).each do |branded|
        Team.where(:name => branded.name).where(:logo => nil).each do |unbranded|
          unbranded.replace_branding_from branded
          unbranded.save
        end
      end
    end
  end


end

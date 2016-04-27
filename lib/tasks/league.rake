
namespace :league do

  desc "exclude prefixed games from standings"
  task :exclude_prefixed_games => :environment do
    Game.where('text_before IS NOT NULL').where("text_before != ''").each do |game|
      game.update_attributes(exclude_from_team_records: true)
    end
  end

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
      puts "Resetting Skater Records"
      Hockey::Skater::Record.all.each{|record| record.reset! }
      puts "Resetting Goalie Records"
      Hockey::Goaltender::Record.all.each{|record| record.reset! }
      Hockey::Statsheet.all.each do |statsheet|
        puts "---- POSTING #{statsheet.id}"
        Hockey::Statsheet::Processor.post statsheet
        puts "---- DONE POSTING"
      end
    end
  end

  desc "Calculate Team Records"
  task :calculate_team_records => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Team.all.each do |team|
        team.calculate_record
        team.save
      end
    end
  end

  desc "Brandify teams"
  task :brandify_teams => :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      #iterate teams with branding
      Team.where(:logo => nil).each do |unbranded|
        if (branded = Team.where(name: unbranded.name).where("logo IS NOT NULL").order(created_at: :desc).first)
          unbranded.replace_branding_from branded
          unbranded.save
        end
      end
      # Team.where(:logo.ne => nil).each do |branded|
      #   Team.where(:name => branded.name).where(:logo => nil).each do |unbranded|
      #     unbranded.replace_branding_from branded
      #     unbranded.save
      #   end
      # end
    end
  end


end

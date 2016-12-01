


require 'csv'
require 'chronic'

namespace :league do

  task :recalculate_penalty_types => :environment do
    count = Hockey::Skater::Result.where('penalties > 0').count
    Hockey::Skater::Result.where('penalties > 0').each_with_index do |result, i|
      puts "#{i} of #{count}"
      result.recalculate_penalty_types!
    end
  end

  task :recalculate_skater_records_for_penalties => :environment do
    count = Hockey::Skater::Record.where('penalties > 0').count
    Hockey::Skater::Record.where('penalties > 0').each_with_index do |result, i|
      puts "#{i} of #{count}"
      result.recalculate!
    end
  end

  task :fix_erroneous_penalty_minutes => :environment do
    penalties = Hockey::Penalty.where('duration NOT IN (2,4,5,10)')
    count = penalties.count
    penalties.each_with_index do |penalty, i|
      puts "#{i} of #{count}"
      penalty.duration = 2  if penalty.severity == 'Minor'
      penalty.duration = 5  if penalty.severity == 'Major'
      penalty.duration = 10 if penalty.severity == 'Misconduct'
      penalty.duration = 10 if penalty.severity == 'Game misconduct'
      penalty.save
    end
  end

  task :correct_game_misconduct_penalties => :environment do
    Hockey::Penalty.where(severity: 'Game misconduct').each do |penalty|
      next unless penalty.committed_by
      penalty.committed_by.game_misconduct_penalties += 1
      penalty.committed_by.save
      puts "#{penalty.committed_by.id}: #{penalty.committed_by.game_misconduct_penalties}"
    end
  end

  desc "correct inverted player names"
  task :correct_inverted_player_names => :environment do
    exceptions = [
      (5670..5678).to_a,
      5684,
      5692,
      (5694..5695).to_a,
      (5699..5701).to_a,
      (5715..5729).to_a,
      (5993..6466).to_a
    ].flatten
    puts "exceptions: #{exceptions}"
    players = Player.joins(:team)
                    .where("league_teams.season_id = 5 AND league_teams.division_id IN (1,2,5)")
                    .order(:id)
    players.each do |player|
      if exceptions.include?(player.id)
        puts "skipping #{player.id} - #{player.first_name} #{player.last_name}"
      else
        puts "inverting #{player.id} - #{player.first_name} #{player.last_name}"
        player.update_attributes first_name: player.last_name, last_name: player.first_name
      end
    end
  end

  desc "exclude prefixed games from standings"
  task :exclude_prefixed_games => :environment do
    Game.where('text_before IS NOT NULL').where("text_before != ''").each do |game|
      game.update_attributes(exclude_from_team_records: true)
    end
  end

  desc "fires reset_record method for teams that have null records"
  task :reset_null_records => :environment do
    Team.unscoped.where(games_played: nil).each do |team|
      team.reset_record
      team.save
      puts "Record reset for #{team.name} (#{team.id})"
    end
  end

  desc "retriggers player statistics for specified season"
  task :recalculate_player_results, [:season] => :environment do |t, args|
    League::Game.for_season(args[:season]).where('statsheet_id IS NOT NULL').includes(statsheet: [:goals, :penalties]).each do |game|
      puts '--------------------------'
      puts game.summary
      puts '--------------------------'
      statsheet = game.statsheet;
      repost = statsheet.posted;
      if statsheet.posted
        puts '- unposting statsheet'
        Hockey::Statsheet::Processor.unpost statsheet
      end
      statsheet.transaction do
        puts '- recalculating goals'
        goal_service = Hockey::GoalService.new(statsheet)
        statsheet.goals.each do |goal|
          print '.'
          goal_service.update_player_results!(goal, 1)
        end
        puts '- recalculating penalties'
        penalty_service = Hockey::PenaltyService.new(statsheet)
        statsheet.penalties.each do |penalty|
          print '.'
          penalty_service.update_player_results!(penalty, 1)
        end
      end
      if repost
        puts '- reposting statsheet'
        statsheet.skaters.reload
        Hockey::Statsheet::Processor.post statsheet
      end
    end
  end

  desc "retriggers player statistics for specified season"
  task :recalculate_goalie_games_played, [:season] => :environment do |t, args|
    League::Game.for_season(args[:season]).where('statsheet_id IS NOT NULL').includes(statsheet: [:goals, :penalties]).each do |game|
      puts '--------------------------'
      puts game.summary
      puts '--------------------------'
      statsheet = game.statsheet;
      repost = statsheet.posted;
      if statsheet.posted
        puts '- unposting statsheet'
        Hockey::Statsheet::Processor.unpost statsheet
      end
      statsheet.transaction do
        puts '- setting games_played'
        statsheet.goaltenders.each do |goalie|
          goalie.games_played = 1
          goalie.save!
        end
      end
      if repost
        puts '- reposting statsheet'
        statsheet.goaltenders.reload
        Hockey::Statsheet::Processor.post statsheet
      end
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
      Hockey::Skater::Record.delete_all
      puts "Resetting Goalie Records"
      Hockey::Goaltender::Record.delete_all
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
      League::Team.where(:logo => nil).each do |unbranded|
        if (branded = League::Team.where(name: unbranded.name).where("logo IS NOT NULL").order(created_at: :desc).first)
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

  desc "Load Games"
  task :load_games => :environment do
    Tenant.current = Tenant.first
    path = File.expand_path("games.csv", File.dirname(__FILE__))
    puts "path: #{path}"
    games = CSV.read(path, headers: true)
    games = games.map do |g|
      hash = {}
      g.each do |prop|
        hash[prop[0].to_sym] = prop[1]
      end
      hash
    end
    Time.zone = "UTC"
    Chronic.time_class = Time.zone
    games.each do |g|
      g[:starts_on] = Chronic.parse(g[:date] + ' ' + g[:time])
      g.delete :date
      g.delete :time
      game = League::Game.create(g)
      if (game.save)
        puts "New Game with Id: #{game.id}"
      else
        puts "ERROR"
        puts game.errors.to_json
      end
    end
  end

  desc "Load Rosters"
  task :load_rosters => :environment do
    Tenant.current = Tenant.first
    # path = File.expand_path("games.csv", File.dirname(__FILE__))
    # puts "path: #{path}"
    data = Net::HTTP.get(URI.parse('https://s3.amazonaws.com/sportified/rosters.csv'))
    players = CSV.parse(data, headers: true)
    players = players.map do |g|
      hash = {}
      g.each do |prop|
        hash[prop[0].to_sym] = prop[1]
      end
      hash
    end
    players.each do |p|
      player = Player.create(p)
      player.email = player.email.downcase unless player.email.blank?
      if (player.save)
        puts "New Player with Id: #{player.id}"
      else
        puts "ERROR"
      end
    end
  end

end

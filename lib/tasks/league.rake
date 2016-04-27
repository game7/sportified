
namespace :league do

  desc "exclude prefixed games from standings"
  task :exclude_prefixed_games => :environment do
    Game.where('text_before IS NOT NULL').where("text_before != ''").each do |game|
      game.update_attributes(exclude_from_team_records: true)
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

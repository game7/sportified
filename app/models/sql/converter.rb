module Sql
  class Converter
    
    def initialize
      @converter = ConvertToSql.new
      @session = Mongoid::Sessions.default      
    end
    
    def section(name)
      puts
      puts name
      puts '--------------------------------'
    end
    
    def all
      hosting
      content
      league
    end
    
    def hosting
      tenants
      users
    end
    
    def content
      pages
      posts
    end
    
    def league
      seasons
      leagues
      clubs
      teams
      players
      locations
      events
      team_records
      statsheets
    end
    
    def tenants
      section "Tenants"
      @session['tenants'].find.each do |mongo_tenant|
        tenant = @converter.convert(mongo_tenant, Tenant) if mongo_tenant[:name]
      end    
      # set first tenant to localhost if non production
      Tenant.first.update_attributes!(host: 'localhost') unless Rails.env == 'production'        
    end
    
    def users
      section "Users"
      @session['users'].find.each do |mongo_user|
        next unless mongo_user['roles']
        user = @converter.convert(mongo_user, User)
        mongo_user[:roles].each do |mongo_role|
          tenant = Tenant.where(:mongo_id => mongo_role[:tenant_id].to_s).first || {}
          puts mongo_role.merge(:tenant_id => tenant[:id]).except('_id')
          user.roles.create(mongo_role.merge(:tenant_id => tenant[:id]).except('_id'))
        end if mongo_user[:roles] && user.roles.count == 0
      end
    end

    def pages
      section "Pages"
      @session['pages'].find.sort(tree: 1).each do |mongo_page|
        page = @converter.convert(mongo_page, Page)
        if mongo_page['sections']
          mongo_page['sections'].each do |mongo_section|
            section = @converter.convert(mongo_section, Section, { :page => page })
          end 
        end
        if mongo_page['blocks']
          mongo_page['blocks'].each do |mongo_block|
            section = Section.where(:mongo_id => mongo_block[:section_id].to_s).first
            block = @converter.convert(mongo_block, mongo_block['_type'].constantize, { :page => page, :section_id => section ? section.id : nil })
          end
        end
      end
    end
    
    def posts
      section "Posts"
      @session['posts'].find.each do |mongo_post|
        post = @converter.convert(mongo_post, Post)
      end
    end

    def seasons
      section "Seasons"
      @session['seasons'].find.each do |mongo_season|
        season = @converter.convert(mongo_season, Season)
      end
    end
    
    def leagues
      section "Leagues"
      @session['leagues'].find.each do |mongo_league|
        league = @converter.convert(mongo_league, League)
        league.seasons.clear
        mongo_league['season_ids'].each do |season_id|
          season = Season.where(:mongo_id => season_id.to_s).first
          league.seasons << season if season
        end
      end      
    end
    
    def clubs
      section "Clubs"
      @session['clubs'].find.each do |mongo_club|
        club = @converter.convert(mongo_club, Club)
      end
    end

    def teams
      section "Teams"
      teams = @session['teams'].find
      total = teams.count
      teams.each_with_index do |mongo_team, i|
        team = @converter.convert(mongo_team, Team)
        print " #{i} of #{total}\r"
        $stdout.flush
      end
      puts " #{total} of #{total}"
    end

    def players
      section "Players"
      Player.delete_all
      players = @session['players'].find
      total = players.count
      players.batch_size(400).each_with_index do |mongo_player, i|
        player = @converter.convert(mongo_player, Player)
        print " #{i} of #{total}\r"
        $stdout.flush        
      end
      puts " #{total} of #{total}"      
    end

    def locations
      section "Locations"
      venues = @session['venues'].find
      total = venues.count
      venues.each_with_index do |mongo_venue, i|
        location = @converter.convert(mongo_venue, Location)
        print " #{i} of #{total}\r"
        $stdout.flush        
      end
      puts " #{total} of #{total}"         
    end

    def events
      section "Events"
      events = @session['events'].find
      total = events.count
      events.each_with_index do |mongo_event, i|
        if mongo_event['_type'] == 'Game'
          event = @converter.convert(mongo_event, Game)
        else
          event = @converter.convert(mongo_event, Event)
        end
        print " #{i} of #{total}\r"
        $stdout.flush        
      end
      puts " #{total} of #{total}" 
    end

    def team_records
      section "Team Records"
      total = 0
      Tenant.all.each do |tenant|
        Tenant.current = tenant
        teams = Team.all
        total += teams.count
        teams.each_with_index do |team, i|
          team.reset_record
          team.calculate_record
          team.save
          print " #{i} of #{total}\r"
          $stdout.flush        
        end        
      end
      puts " #{total} of #{total}"
      puts
    end    
    
    def statsheets
      section "Statsheets"
      # Hockey::Skater.delete_all
      # Hockey::Goaltender.delete_all
      # Hockey::Goal.delete_all
      # Hockey::Penalty.delete_all
      # Hockey::Statsheet.delete_all
      total = @session['statsheets'].find.count
      @session['statsheets'].find.sort('_id' => -1).batch_size(10).each_with_index do |mongo_statsheet, i|
        #ActiveRecord::Base.transaction do
          statsheet = @converter.convert(mongo_statsheet, Hockey::Statsheet)
          #next unless statsheet.mongo_id.to_s == "5661ea7a346430000f380000"
          mongo_statsheet['players'].each do |mongo_player|
            skater = @converter.convert(mongo_player, Hockey::Skater::Result, { statsheet: statsheet })
            if mongo_player['g_gp'] == 1
              goalie = @converter.convert(mongo_player, Hockey::Goaltender::Result, { statsheet: statsheet })
            end
          end if mongo_statsheet['players']

          # there are some cases where a goalie has been logged but not related to an individual
          # on the GAME roster, in which case we need capture from the goalie log
          mongo_statsheet['goaltenders'].each do |mongo_goalie|
            if statsheet.goaltenders.for_side(mongo_goalie[:side]).first == nil
              attrs = {
                jersey_number: mongo_goalie[:plr],
                team: mongo_goalie[:side] == 'home' ? statsheet.home_team : statsheet.away_team,
                minutes_played: mongo_goalie[:min_1] + mongo_goalie[:min_2] + mongo_goalie[:min_3] + mongo_goalie[:min_ot],
                shots_against: mongo_goalie[:shots_1] + mongo_goalie[:shots_2] + mongo_goalie[:shots_3] + mongo_goalie[:shots_ot],
                goals_against: mongo_goalie[:goals_1] + mongo_goalie[:goals_2] + mongo_goalie[:goals_3] + mongo_goalie[:goals_ot]
              }
              statsheet.goaltenders.create attrs
            end
          end if mongo_statsheet['goaltenders']

          mongo_statsheet['events'].each do |mongo_event|
            type = mongo_event['_type']
            if type == 'Hockey::Goal'
              goal = @converter.convert(mongo_event, Hockey::Goal, { statsheet: statsheet })
            elsif type == 'Hockey::Penalty'
              penalty = @converter.convert(mongo_event, Hockey::Penalty, { statsheet: statsheet })          
            end
          end if mongo_statsheet['events']

          Hockey::Statsheet::Processor.unpost statsheet if statsheet.posted
          Hockey::Statsheet::Processor.post statsheet

        #end
        print " #{i} of #{total}\r"
        $stdout.flush          
      end
      puts " #{total} of #{total}"        
    end
    
  end
end
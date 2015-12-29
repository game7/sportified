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
      @session['players'].find.each do |mongo_player|
        player = @converter.convert(mongo_player, Player)
      end
    end

    def locations
      section "Locations"
      @session['venues'].find.each do |mongo_venue|
        location = @converter.convert(mongo_venue, Location)
      end
    end

    def events
      section "Events"
      @session['events'].find.each do |mongo_event|
        if mongo_event['_type'] == 'Game'
          event = @converter.convert(mongo_event, Game)
        else
          event = @converter.convert(mongo_event, Event)
        end
      end
    end
    
    def statsheets
      section "Statsheets"
      count = 0
      total = 0
      @session['statsheets'].find.batch_size(10).each_with_index do |mongo_statsheet, i|
        #ActiveRecord::Base.transaction do
          start = Time.now
          #puts
          #puts 'statsheet'
          statsheet = @converter.convert(mongo_statsheet, Hockey::Statsheet)
          #puts
          #puts '- players'
          mongo_statsheet['players'].each do |mongo_player|
            skater = @converter.convert(mongo_player, Hockey::Skater::Result, { statsheet: statsheet })
            if (mongo_player['g_gp'] == 1)
              goalie = @converter.convert(mongo_player, Hockey::Goaltender::Result, { statsheet: statsheet })
            end
          end if mongo_statsheet['players']
          #puts
          #puts '- events'
          mongo_statsheet['events'].each do |mongo_event|
            type = mongo_event['_type']
            if type == 'Hockey::Goal'
              goal = @converter.convert(mongo_event, Hockey::Goal, { statsheet: statsheet })
            elsif type == 'Hockey::Penalty'
              penalty = @converter.convert(mongo_event, Hockey::Penalty, { statsheet: statsheet })          
            end
          end if mongo_statsheet['events']
          #puts
          duration = Time.now - start
          count += 1
          total += duration
          puts "completed: #{duration}, count: #{count}, duration: #{total}, average: #{total / count}"
        #end
      end
    end
    
  end
end
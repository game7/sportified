namespace :mongo do
  desc "converts mongo models to postgresql models"
  task :to_sql, [:section]=> :environment do
    converter = Sql::ConvertToSql.new
    session = Mongoid::Sessions.default
  
    section "Tenants"
    session['tenants'].find.each do |mongo_tenant|
      tenant = converter.convert(mongo_tenant, Tenant)
    end
    
    # set first tenant to localhost if non production
    Tenant.first.update_attributes!(host: 'localhost') unless Rails.env == 'production'
    
    section "Users"
    session['users'].find.each do |mongo_user|
      next unless mongo_user['roles']
      user = converter.convert(mongo_user, User)
    end
    
    # set user/2 to super_admin if non production
    User.find(2).roles << UserRole.super_admin
    
    section "Pages"
    session['pages'].find.each do |mongo_page|
      page = converter.convert(mongo_page, Page)
      if mongo_page['sections']
        mongo_page['sections'].each do |mongo_section|
          section = converter.convert(mongo_section, Section, { :page => page })
        end 
      end
      if mongo_page['blocks']
        mongo_page['blocks'].each do |mongo_block|
          section = Section.where(:mongo_id => mongo_block[:section_id].to_s).first
          block = converter.convert(mongo_block, mongo_block['_type'].constantize, { :page => page, :section_id => section ? section.id : nil })
        end
      end
    end
    
    section "Posts"
    session['posts'].find.each do |mongo_post|
      post = converter.convert(mongo_post, Post)
    end
    
    section "Seasons"
    session['seasons'].find.each do |mongo_season|
      season = converter.convert(mongo_season, Season)
    end
    
    section "Leagues"
    session['leagues'].find.each do |mongo_league|
      league = converter.convert(mongo_league, League)
      mongo_league['season_ids'].each do |season_id|
        league.seasons << Season.where(:mongo_id => season_id.to_s).first
      end
    end
    
    section "Clubs"
    session['clubs'].find.each do |mongo_club|
      club = converter.convert(mongo_club, Club)
    end    
    
    section "Teams"
    session['teams'].find.each do |mongo_team|
      team = converter.convert(mongo_team, Team)
      #if mongo_team['logo']
      #  team.remote_logo_url = "https://sportified.s3.amazonaws.com/uploads/#{team.tenant.slug}/#{team.class.name.pluralize.downcase}/logo/#{team.mongo_id}/" + mongo_team['logo']
      #  puts team.remote_logo_url
      #end      
    end
    
    section "Players"
    session['players'].find.each do |mongo_player|
      player = converter.convert(mongo_player, Player)
    end
    
    section "Locations"
    session['venues'].find.each do |mongo_venue|
      location = converter.convert(mongo_venue, Location)
    end
    
    section "Events"
    session['events'].find.each do |mongo_event|
      if mongo_event['type'] == 'Game'
        event = converter.convert(mongo_event, Game)
      else
        event = converter.convert(mongo_event, Event)
      end
    end
    
  end
  
  task :current, [:section]=> :environment do
    converter = Sql::ConvertToSql.new
    session = Mongoid::Sessions.default
    
    section "Events"
    session['events'].find.each_with_index do |mongo_event, i|
      if mongo_event['_type'] == 'Game'
        event = converter.convert(mongo_event, Game)
      else
        event = converter.convert(mongo_event, Event)
      end
    end
    
  end  
  
  def section(name)
    puts
    puts name
    puts '--------------------------------'
  end
  
end

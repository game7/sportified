namespace :mongo do
  desc "converts mongo models to postgresql models"
  task :to_sql => :environment do
    converter = Sql::ConvertToSql.new
    session = Mongoid::Sessions.default
  
    section "Tenants"
    session['tenants'].find.each do |mongo_tenant|
      tenant = converter.convert(mongo_tenant, Tenant)
    end
    
    section "Users"
    session['users'].find.each do |mongo_user|
      next unless mongo_user['roles']
      user = converter.convert(mongo_user, User)
    end
    
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

  end
  
  def section(name)
    puts
    puts name
    puts '--------------------------------'
  end
  
end

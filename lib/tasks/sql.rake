namespace :mongo do
  desc "converts mongo models to postgresql models"
  task :to_sql => :environment do
    converter = Sql::ConvertToSql.new
  
    section "Tenants"
    Tenant.all.each do |mongo_tenant|
      tenant = converter.convert(mongo_tenant, Sql::Tenant)
      puts "-- Tenant #{tenant.id} updated"
    end
    
    section "Users"
    User.all.each do |mongo_user|
      next unless mongo_user.roles.count > 0
      user = converter.convert(mongo_user, Sql::User)
      user.save(validate: false)
      puts "-- User #{user.id} updated"
    end
    
  end
  
  def section(name)
    puts
    puts name
    puts '--------------------------------'
  end
  
end

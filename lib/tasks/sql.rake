namespace :mongo do
  
  desc "converts mongo models to postgresql models"
  task :to_sql, [:section] => :environment do |t, args|
    converter = Sql::Converter.new
    converter.send(args[:section] || :all)
  end

  desc "drops, creates and remigrates the sql database"
  task :rebuild, [:section] => :environment do |t, args|
  	ENV['STEP'] = "100"
  	Rake::Task["db:rollback"].invoke
  	Rake::Task["db:create"].invoke
  	Rake::Task["db:migrate"].invoke
  end   

  
end

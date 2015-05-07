require 'JSON'

namespace :mongo do
  desc "converts mongo models to postgresql models"
  task :to_sql, [:section] => :environment do |t, args|
    converter = Sql::Converter.new
    converter.send(args[:section] || :all)
  end 

  
end

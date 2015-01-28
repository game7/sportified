desc "converts mongo models to postgresql models"
task :mongo_to_sql => :environment do
  converter = Sql::ConvertToSql.new
  converter.convert
end

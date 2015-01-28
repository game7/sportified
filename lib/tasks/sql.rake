desc "converts mongo models to postgresql models"
task :mongo_to_sql => :environment do
  Tenant.all.each do |mongo|
    sql = Sql::Tenant.where(:mongo_id => mongo.id.to_s).first || Sql::Tenant.new
    mongo.attributes.keys.each do |key|
      if key == "_id"
        sql.mongo_id = mongo.id.to_s
      elsif mongo.respond_to?(key) && !key.end_with?("_id")
        sql.send("#{key}=", mongo.send(key))
      end
    end
    sql.save!
  end
end

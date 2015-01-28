module Sql
  class ConvertToSql
    
    def convert
      
      #::User.all.each do |user|
      #  sql_user = find_or_create(user, ::Sql::User)
      #  set_attributes(user, sql_user)
      #  sql_user.save!
      #end
            
      ::Tenant.all.each do |mongo|
        sql = find_or_create(mongo, ::Sql::Tenant)
        set_attributes(mongo, sql)
        sql.save!
        
        ::Tenant.current = mongo
        
      end
      
    end
    
    private
    
    def find_or_create(mongo, ar_type)
      puts "Looking for #{ar_type.to_s} -> #{mongo.id.to_s}"
      sql = ar_type.where(:mongo_id => mongo.id.to_s).first
      if sql
        puts "Object Exists"
      else
        puts "New Object"
        sql = ar_type.new
      end
      sql
    end
    
    def set_attributes(mongo, sql)
      mongo.attributes.keys.each do |key|
        if key == "_id"
          sql.mongo_id = mongo.id.to_s
        elsif mongo.respond_to?(key) && !key.end_with?("_id")
          sql.send("#{key}=", mongo.send(key))
        end
      end      
    end
    
  end
end
module Sql
  class ConvertToSql
    
    def convert(mongo, ar_type, initial_attrs = {})
      sql = ar_object_for(mongo, ar_type).tap do |sql|
        sql.assign_attributes(initial_attrs)
        
        keys(mongo, sql).each do |key|

          begin
            if key == "_id"
              sql.mongo_id = mongo.id.to_s
            elsif sql.respond_to?("apply_mongo_#{key}!")
              sql.send("apply_mongo_#{key}!", mongo.send(key))
            elsif mongo.respond_to?(key) && !key.end_with?("_id")
              sql.send("#{key}=", mongo.send(key))
            end
          rescue Exception => ex
            puts "Error while updating #{key}"
            puts ex.message
          end
        end

        begin
          sql.save!
        rescue Exception => ex
          puts "Error(s) while saving"
          puts sql.errors.full_messages
        end
        
        sql
        
      end
    end
    
    private
    
    def ar_object_for(mongo, ar_type)
      ar_type.where(:mongo_id => mongo.id.to_s).first || ar_type.new
    end
    
    def keys(mongo, sql)
      (mongo.attributes.keys + sql.attributes.keys).uniq - ["id"]
    end
    
  end
end
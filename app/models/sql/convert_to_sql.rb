module Sql
  class ConvertToSql
    
    def convert(mongo, ar_type, initial_attrs = {})
      sql = ar_object_for(mongo, ar_type).tap do |sql|
        sql.assign_attributes(initial_attrs)
        
        #if sql.new_record?
        #  #puts "NEW #{ar_type.to_s}"
        #  print 'N'
        #else
        #  #puts "UPDATE #{ar_type.to_s} #{sql.id}"
        #  print 'U'
        #end

        keys(mongo, sql).each do |key|
          begin
            if key == "_id"
              sql.mongo_id = mongo['_id'].to_s
            elsif sql.respond_to?("apply_mongo_#{key}!")
              sql.send("apply_mongo_#{key}!", mongo[key])
            elsif sql.respond_to?(key) && mongo[key] && !key.end_with?("_id")
              sql.send("#{key}=", mongo[key])
            end
          rescue Exception => ex
            puts
            puts "ERROR while MAPPING #{key}"
            puts ex.message
            puts "sql: #{JSON.pretty_generate(sql.attributes.keys)}"
          end
        end
        
        if (sql.respond_to?('apply_mongo!'))
          begin
            sql.send('apply_mongo!', mongo)
          rescue Exception => ex
            puts
            puts "ERROR while MAPPING"
            puts ex.message
            puts JSON.pretty_generate(mongo)
            puts sql.to_yaml
          end        
        end
        
        yield(mongo, sql) if block_given?
        
        
        unless sql.save(validate: ar_type != 'User')
          puts
          puts "ERROR while SAVING"
          puts sql.errors.full_messages
        end
        
        sql
        
      end
    end
    
    private
    
    def ar_object_for(mongo, ar_type)
      ar_type.unscoped.where(:mongo_id => mongo['_id'].to_s).first || ar_type.new
    end
    
    def keys(mongo, sql)
      (mongo.keys + sql.attributes.keys).uniq - ["id"]
    end
    
  end
end
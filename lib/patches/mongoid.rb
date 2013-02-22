module Mongoid #:nodoc:
  # do NOT validate the other side of references_and_referenced_in_many association
  module Relations #:nodoc:
    
    class Many < Proxy
      def <<(*args)
        options = default_options(args)
        args.flatten.each do |doc|
          return doc unless doc
          append(doc, options)
          doc.save(:validate => false) if base.persisted? && !options[:binding]
        end
      end
    end
    
    module Referenced #:nodoc:
      class Many < Relations::Many
        def bind(options = {})
          binding.bind(options)
          target.map {|e| e.save(:validate => false)} if base.persisted? && !options[:binding]
        end
      end
      
      class ManyToMany < Referenced::Many
        def <<(*args)
          options = default_options(args)
          super(args)
        end
      end
    end
  end
  
  # monkey-patch issue with multiple sort on embedded
#  module Contextual
#    class Memory
#      def in_place_sort(values)
#        documents.sort! do |a, b|
#          a_value, b_value = [], []
#          values.keys.each do |field|
#            a_value << (values[field] < 0 ? b[field] : a[field])
#            b_value << (values[field] < 0 ? a[field] : b[field])
#          end
#          a_value <=> b_value
#        end  
#      end      
#    end
#  end
end

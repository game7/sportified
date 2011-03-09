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
end

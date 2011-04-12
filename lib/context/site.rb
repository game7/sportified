module Context
  module Site
    extend ActiveSupport::Concern
    
    included do
      referenced_in :site
      validates_presence_of :site
    end

    module ClassMethods
      def for_site(s)
        id = s.class == Site ? s.id : s
        where(:site_id => id)
      end      
    end

  end
end


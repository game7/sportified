module Blocks
  class Block
    include Mongoid::Document
    include Mongoid::Timestamps

    field :position, :type => Integer

    embedded_in :page
    
    def self.actions
      []
    end

    def class_name
      self.class.to_s.titlecase
    end  
    
    def friendly_name
      self.class.to_s.sub("Blocks::","").humanize
    end  
  end
end
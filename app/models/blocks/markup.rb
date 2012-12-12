module Blocks
  class Markup < Block
    
    def self.actions 
      %w{ edit }
    end
    
    field :body
  end
end
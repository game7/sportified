module Blocks
  class Text < Block
  
    def self.actions 
      %w{ edit }
    end
    
    field :title
    field :caption
    field :body
  end
end
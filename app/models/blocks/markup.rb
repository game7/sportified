module Blocks
  class Markup < Block
    
    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      body: :string
    
  end
end
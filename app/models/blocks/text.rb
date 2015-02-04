module Blocks
  class Text < Block
    
    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      title: :string,
      caption: :string,
      body: :string
    
  end
end
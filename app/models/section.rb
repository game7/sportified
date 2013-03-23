class Section
  include Mongoid::Document
  
    embedded_in :page
  
    field :pattern
    field :position, :type => Integer, :default => 0
    
    PATTERNS = [
      "100", 
      "50|50",
      "33|66",
      "66|33",
      "25|75",
      "75|25",
      "33|33|33",
      "25|50|25",
      "50|25|25",
      "25|25|50",
      "25|25|25|25"
    ]

    def self.patterns
      @patterns ||= PATTERNS
    end    
    
    def columns
      @columns ||= pattern.split("|")
    end
  
end
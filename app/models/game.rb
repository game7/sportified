class Game
  include Mongoid::Document
  
  field :starts_on, :type => Date
  field :starts_at, :type => Time

  referenced_in :season, :inverse_of => :games

  

end

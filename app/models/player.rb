class Player
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :jersey_number

  referenced_in :team, :inverse_of => :players

end

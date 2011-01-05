class Player
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :jersey_number
  key :first_name, :last_name

  embedded_in :team, :inverse_of => :players

end

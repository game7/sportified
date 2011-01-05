class Game
  include Mongoid::Document
  field :starts_on, :type => Date
  field :starts_at, :type => Time
end

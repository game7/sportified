class Map::Venue
  include Mongoid::Document

  field :name
  referenced_in :venue
  embedded_in :game_upload

  scope :with_name, lambda { |name| where(:name => name) }

end

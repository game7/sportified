class Map::Venue
  include Mongoid::Document

  field :name
  belongs_to :venue
  embedded_in :game_upload

  scope :with_name, ->(name) { where(:name => name) }

end

class Map::Team
  include Mongoid::Document

  field :name
  referenced_in :team
  embedded_in :game_upload

  scope :with_name, lambda { |name| where(:name => name) }

end

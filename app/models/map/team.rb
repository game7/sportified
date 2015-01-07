class Map::Team
  include Mongoid::Document

  field :name
  belongs_to :team
  embedded_in :game_upload

  scope :with_name, ->(name) { where(:name => name) }

end

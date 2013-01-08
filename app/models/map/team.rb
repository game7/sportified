class Map::Team
  include Mongoid::Document

  field :name
  belongs_to :team
  embedded_in :game_upload

  scope :with_name, lambda { |name| where(:name => name) }

end

# == Schema Information
#
# Table name: league_seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  starts_on  :date
#  tenant_id  :integer
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#  program_id :integer
#
# Indexes
#
#  index_league_seasons_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (program_id => programs.id)
#

class League::SeasonSerializer < ActiveModel::Serializer
  type :season
  attributes :id, :program_id, :name, :slug, :starts_on, :created_at, :updated_at
end

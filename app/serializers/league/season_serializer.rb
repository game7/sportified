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

class League::SeasonSerializer < ActiveModel::Serializer
  type :season
  attributes :id, :program_id, :name, :slug, :starts_on, :created_at, :updated_at
end

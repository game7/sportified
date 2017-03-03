# == Schema Information
#
# Table name: league_divisions
#
#  id                  :integer          not null, primary key
#  name                :string
#  slug                :string
#  show_standings      :boolean
#  show_players        :boolean
#  show_statistics     :boolean
#  standings_array     :text             default([]), is an Array
#  tenant_id           :integer
#  mongo_id            :string
#  created_at          :datetime
#  updated_at          :datetime
#  standings_schema_id :string
#  program_id          :integer
#
# Indexes
#
#  index_league_divisions_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_a1b344ef36  (program_id => programs.id)
#

class League::DivisionSerializer < ActiveModel::Serializer
  type :division
  attributes :id, :program_id, :name, :slug, :show_standings, :show_players, :show_statistics, :created_at, :updated_at
end

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

class League::DivisionSerializer < ActiveModel::Serializer
  type :division
  attributes :id, :program_id, :name, :slug, :show_standings, :show_players, :show_statistics, :created_at, :updated_at
end
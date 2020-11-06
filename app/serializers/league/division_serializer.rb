# == Schema Information
#
# Table name: league_divisions
#
#  id                  :integer          not null, primary key
#  name                :string
#  period_length       :integer          default(15)
#  show_players        :boolean
#  show_standings      :boolean
#  show_statistics     :boolean
#  slug                :string
#  standings_array     :text             default([]), is an Array
#  created_at          :datetime
#  updated_at          :datetime
#  program_id          :integer
#  standings_schema_id :string
#  tenant_id           :integer
#
# Indexes
#
#  index_league_divisions_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#
class League::DivisionSerializer < ActiveModel::Serializer
  type :division
  attributes :id, :program_id, :name, :slug, :show_standings, :show_players, :show_statistics, :created_at, :updated_at
end

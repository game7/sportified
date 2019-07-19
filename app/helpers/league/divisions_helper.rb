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
#  created_at          :datetime
#  updated_at          :datetime
#  standings_schema_id :string
#  program_id          :integer
#  period_length       :integer          default(15)
#
# Indexes
#
#  index_league_divisions_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#

module League::DivisionsHelper
end

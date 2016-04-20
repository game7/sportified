# == Schema Information
#
# Table name: league_divisions
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  slug                :string(255)
#  show_standings      :boolean
#  show_players        :boolean
#  show_statistics     :boolean
#  standings_array     :text             default([]), is an Array
#  tenant_id           :integer
#  mongo_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  standings_schema_id :string(255)
#  program_id          :integer
#

require 'rails_helper'

RSpec.describe League::Division, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

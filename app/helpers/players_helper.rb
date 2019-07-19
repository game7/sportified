# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string
#  last_name     :string
#  jersey_number :string
#  birthdate     :date
#  email         :string
#  slug          :string
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#  position      :string
#
# Indexes
#
#  index_players_on_email      (email)
#  index_players_on_team_id    (team_id)
#  index_players_on_tenant_id  (tenant_id)
#

module PlayersHelper
end

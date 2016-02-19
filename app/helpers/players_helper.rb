# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string(255)
#  last_name     :string(255)
#  jersey_number :string(255)
#  birthdate     :date
#  email         :string(255)
#  slug          :string(255)
#  mongo_id      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#

module PlayersHelper
end

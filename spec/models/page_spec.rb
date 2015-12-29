# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  title               :string(255)
#  slug                :string(255)
#  url_path            :string(255)
#  meta_keywords       :text
#  meta_description    :text
#  link_url            :string(255)
#  show_in_menu        :boolean
#  title_in_menu       :string(255)
#  skip_to_first_child :boolean
#  draft               :boolean
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  position            :integer
#  mongo_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'rails_helper'

RSpec.describe Page, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

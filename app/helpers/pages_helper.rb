# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  title               :string
#  slug                :string
#  url_path            :string
#  meta_keywords       :text
#  meta_description    :text
#  link_url            :string
#  show_in_menu        :boolean
#  title_in_menu       :string
#  skip_to_first_child :boolean
#  draft               :boolean
#  ancestry            :string
#  ancestry_depth      :integer
#  position            :integer
#  created_at          :datetime
#  updated_at          :datetime
#  content             :text
#
# Indexes
#
#  index_pages_on_ancestry   (ancestry)
#  index_pages_on_tenant_id  (tenant_id)
#

module PagesHelper
  
  def width_to_span(width)
    'col-sm-' + ( Integer(width) / 100.00 * 12 ).round.to_s
  end
  
end

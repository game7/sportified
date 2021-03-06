# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  ancestry            :string
#  ancestry_depth      :integer
#  content             :text
#  draft               :boolean
#  link_url            :string
#  meta_description    :text
#  meta_keywords       :text
#  position            :integer
#  show_in_menu        :boolean
#  skip_to_first_child :boolean
#  slug                :string
#  title               :string
#  title_in_menu       :string
#  url_path            :string
#  created_at          :datetime
#  updated_at          :datetime
#  tenant_id           :integer
#
# Indexes
#
#  index_pages_on_ancestry   (ancestry)
#  index_pages_on_tenant_id  (tenant_id)
#
require 'test_helper'

class PageTest < ActiveSupport::TestCase
  setup do
    Tenant.current = tenants(:hockey_league_site)
  end

  context :validations do
    should validate_presence_of(:title)
    should validate_presence_of(:slug)
  end

  context :associations do
    should belong_to(:tenant)
    should have_many(:sections)
    should have_many(:blocks)
  end

  context :before_validation do
    should 'set the slug using the title when no menu title provided' do
      attrs = {
        title: 'Some Title'
      }
      page = Page.new(attrs)
      page.valid?
      assert_equal attrs[:title].parameterize, page.slug
    end
    should 'set the slug using the menu title when provided' do
      attrs = {
        title: 'Some Title',
        title_in_menu: 'Menu Title'
      }
      page = Page.new(attrs)
      page.valid?
      assert_equal attrs[:title_in_menu].parameterize, page.slug
    end
    should 'set the path for a standalong' do
      attrs = {
        title: 'Some Title'
      }
      page = Page.new(attrs)
      page.valid?
      assert_equal page.slug, page.url_path
    end
  end
end

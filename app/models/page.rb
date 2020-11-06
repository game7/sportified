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
class Page < ActiveRecord::Base
  has_ancestry orphan_strategy: :rootify, cache_depth: true, touch: true
  include Sportified::TenantScoped

  has_many :sections, :dependent => :destroy
  has_many :blocks, :class_name => "Block", :dependent => :destroy

  before_validation :set_slug
  before_validation :set_path  

  validates :title, presence: true
  validates :slug, presence: true

  scope :with_path, ->(path) { where(:url_path => path) }
  scope :live, ->{ where( :draft => false ) }
  scope :in_menu, ->{ where( :show_in_menu => true ) }

  class << self
    def find_by_path(path)
      page = Page.with_path(path).first if path
      page ||= Page.roots.order(position: :asc).first
    end

    def arrange_as_array(options={}, hash=nil)
      hash ||= arrange(options)

      arr = []
      hash.each do |node, children|
        arr << node
        arr += arrange_as_array(options, children) unless children.nil?
      end
      arr
    end

    def options
      Page.arrange_as_array(:order => :position)
          .collect{|p| [p.name_for_selects, p.id]}
    end

  end

  def name_for_selects
    "#{'-' * depth} #{title}"
  end

  private

    def set_slug
      self.slug = (title_in_menu.presence || title)&.parameterize
    end

    def set_path
      self.url_path = slug && "#{ancestors.collect{|a| a.slug + '/' }.join}#{slug}"
    end

end

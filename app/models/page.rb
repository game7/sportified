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
#  mongo_id            :string
#  created_at          :datetime
#  updated_at          :datetime
#  content             :text
#
# Indexes
#
#  index_pages_on_ancestry   (ancestry)
#  index_pages_on_tenant_id  (tenant_id)
#

class Page < ActiveRecord::Base
  has_ancestry orphan_strategy: :rootify, cache_depth: true, touch: true
  include Sportified::TenantScoped 

  before_save :set_slug, :set_path

  has_many :sections, :dependent => :destroy
  has_many :blocks, :class_name => "Block", :dependent => :destroy

  validates_presence_of :title

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
  end
  
  def name_for_selects
    "#{'-' * depth} #{title}"
  end
  
  def apply_mongo_parent_id!(parent_id)
    self.parent = Page.unscoped.where(:mongo_id => parent_id.to_s).first
  end 
  
  def apply_mongo_sections!(sections)
  end
  
  def apply_mongo_blocks!(blocks)
  end
  
  def apply_mongo_path!(path)
    self.url_path = path
  end
  
  def apply_mongo_depth!(depth)
    self.ancestry_depth = depth
  end  

  private

    def set_slug
      self.slug = (self.title_in_menu.presence || self.title).parameterize
    end

    def set_path
      self.url_path = self.ancestors.collect{|a| a.slug + '/' }.join + self.slug
    end
  
end

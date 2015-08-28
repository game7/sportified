class Page < ActiveRecord::Base
  has_ancestry orphan_strategy: :restrict, cache_depth: true, touch: true
  include Sportified::TenantScoped 

  before_save :set_slug, :set_path

  has_many :sections
  has_many :blocks, :class_name => "Block"

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
    self.parent = Page.where(:mongo_id => parent_id.to_s).first
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

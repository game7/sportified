require 'bson'

class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  include Sportified::TenantScoped

  before_save :set_slug, :set_path, :set_tree
  after_save :cascade_save
  after_rearrange :set_path
  before_destroy :delete_descendants

  field :title 
  field :slug
  field :path
  
  field :meta_keywords
  field :meta_description
  
  field :link_url
  field :show_in_menu, :type => Boolean, :default => true
  field :title_in_menu
  field :skip_to_first_child, :type => Boolean, :default => false

  field :draft, :type => Boolean, :default => false

  field :tree 

  embeds_many :sections, :class_name => "Section", :cascade_callbacks => true
  embeds_many :blocks, :class_name => "Block"

  validates_presence_of :title

  scope :top_level, where( :parent_id => nil )
  scope :with_path, ->(path) { where(:path => path) }
  
  class << self
    def sorted_as_tree
      crit = Page.all
      crit.options = {}
      crit.ascending(:tree)
    end
  end
  
  scope :live, where( :draft => false )
  scope :in_menu, where( :show_in_menu => true )  
  
  class << self
    def find_by_path(path)
      page = Page.with_path(path).first if path
      page ||= Page.sorted_as_tree.first
    end
  end

  private

    def set_tree
      self.tree = (parent ? parent.tree : "") + self.position.to_i.to_s
    end

    def set_slug
      self.slug = (self.title_in_menu.presence || self.title).parameterize
    end

    def set_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end
    
    def tree_slug_or_path_changed?
      self.changes.include?("tree") || self.changed.include?("slug") || self.changes.include?("path")
    end
    
    def cascade_save
      self.children.all.each{|p|p.save} if tree_slug_or_path_changed?
    end

end

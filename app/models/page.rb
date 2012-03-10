class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  include Sportified::TenantScoped

  before_save :set_slug, :set_path, :set_tree
  after_rearrange :set_path
  before_destroy :delete_descendants

  field :title 
  field :slug
  field :path
  
  field :meta_keywords
  field :meta_description
  
  field :link_url
  field :show_in_menu, :type => Boolean, :default => true
  field :skip_to_first_child, :type => Boolean, :default => false

  field :draft, :type => Boolean, :default => false

  field :tree 

  #embeds_many :blocks#, :default_order => :position.asc
  #embeds_many :layouts#, :default_order => :position.asc

  validates_presence_of :title

  scope :top_level, :where => { :parent_id => nil }
  scope :with_path, lambda { |path| { :where => { :path => path } } }
  class << self
    def sorted_as_tree
      unscoped.ascending(:tree )
    end
  end
  scope :live, :where => { :draft => false }
  scope :in_menu, :where => { :show_in_menu => true }

  #def blocks_grouped_by_panel
  #  panels = { :default => [] }
  #  layouts.each do |layout|
  #    layout.panel_ids.each{|id| panels[id.to_s] = [] }
  #  end
  #  blocks.asc(:position).each do |block|
  #    if panels.has_key?(block.panel_id)
  #      panels[block.panel_id] << block
  #    else
  #      panels[:default] << block
  #    end
  #  end
  #  panels
  #end

  private

    def set_tree
      self.tree = (parent ? parent.tree : "") + self.position.to_i.to_s
    end

    def set_slug
      self.slug = self.title.parameterize
    end

    def set_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

end

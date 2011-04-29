class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  include Sportified::SiteContext
  cache

  default_scope

  before_save :set_slug, :set_path, :set_block_positions, :set_tree
  after_rearrange :set_path

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

  embeds_many :blocks, :default_order => :position.asc
  #reflect_on_association(:blocks).options[:default_order] = :position.asc

  embeds_many :layouts, :default_order => :position.asc

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

  def url
    if self.link_url.present?
      self.link_url
    else
      {:controller => "/pages", :action => "show", :path => self.path}
    end
  end

  def move_block_to_top(block)
    blocks.move_to_front(block)
  end

  def move_block_to_bottom(block)
    blocks.move_to_back(block)
  end

  def move_block_up(block)
    blocks.move_forward(block)
  end

  def move_block_down(block)
    blocks.move_back(block)   
  end

  def block_is_first?(block)
    blocks.first?(block)
  end

  def block_is_last?(block)
    blocks.last?(block)
  end

  def assign_block_positions
    blocks.each_with_index{|block, index| block.position = index }
  end

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

    def set_block_positions
      blocks.each_with_index{|block, index| block.position = index }
    end

end

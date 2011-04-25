class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  include Sportified::SiteContext
  cache

  before_create :set_position
  before_save :set_slug, :set_path, :set_grouping, :set_block_positions
  after_rearrange :set_path, :set_grouping

  field :title 
  field :slug
  field :path
  
  field :meta_keywords
  field :meta_description
  
  field :link_url
  field :show_in_menu, :type => Boolean, :default => true
  field :skip_to_first_child, :type => Boolean, :default => false

  field :draft, :type => Boolean, :default => false
  
  field :level, :type => Integer
  field :group, :type => Integer

  embeds_many :blocks, :default_order => :position.asc
  #reflect_on_association(:blocks).options[:default_order] = :position.asc

  validates_presence_of :title
  validates_presence_of :position

  scope :top_level, :where => { :parent_id => nil }
  scope :with_path, lambda { |path| { :where => { :path => path } } }
  scope :sorted_as_tree, order_by(:group.asc, :level.asc, :position.asc)
  scope :live, :where => { :draft => false }
  scope :in_menu, :where => { :show_in_menu => true }

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

  class << self
    def max_position(site)
      Page.for_site(site).max(:position).to_i
    end
  end

  private

    def set_slug
      self.slug = self.title.parameterize
    end

    def set_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

    def set_position
      if self.parent_id.blank?
        self.position = Page.max_position(self.site_id) + 1
      else
        self.position = self.siblings.max(:position).to_i + 1
      end
    end

    def set_grouping
      self.level = self.root? ? 0 : self.parent.level + 1
      self.group = self.root? ? self.position : self.root.group
    end

    def set_block_positions
      blocks.each_with_index{|block, index| block.position = index }
    end

end

class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  cache

  before_save :set_slug, :set_path, :set_grouping
  after_rearrange :set_path, :set_grouping

  field :title 
  field :slug
  field :path
  field :meta_keywords
  field :meta_description
  field :level, :type => Integer
  field :group, :type => Integer

  embeds_many :blocks

  validates_presence_of :title

  scope :top_level, :where => { :parent_id => nil }
  scope :with_path, lambda { |path| { :where => { :path => path } } }
  scope :sorted_as_tree, order_by(:group.asc, :level.asc, :position.asc)

  private

    def set_slug
      self.slug = self.title.parameterize
    end

    def set_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

    def set_grouping
      self.level = self.root? ? 0 : self.parent.level + 1
      self.group = self.root? ? self.position : self.root.position
    end


end

class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  cache

  before_save :set_slug, :set_path, :set_level
  after_rearrange :set_path

  field :title 
  field :slug
  field :path
  field :meta_keywords
  field :meta_description
  field :level, :type => Integer

  embeds_many :blocks

  validates_presence_of :title

  scope :top_level, :where => { :parent_id => nil }
  scope :with_path, lambda { |path| { :where => { :path => path } } }

  private

    def set_slug
      self.slug = self.title.parameterize
    end

    def set_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

    def set_level
      self.level = self.parent_id ? self.parent.level + 1 : 0
    end

end

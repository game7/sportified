class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  cache

  field :title 
  field :meta_keywords
  field :meta_description

  embeds_many :blocks

  validates_presence_of :title

  scope :top_level, :where => { :parent_id => nil }

end

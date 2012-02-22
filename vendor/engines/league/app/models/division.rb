class Division
  include Mongoid::Document
  include Sportified::PublishesMessages
  cache
 
  field :name
  field :slug

  belongs_to :season


  references_many :teams

  validates_presence_of :name

  before_save do |division|
    division.slug = division.name.parameterize
  end
  before_save :prepare_division_renamed_message
  def prepare_division_renamed_message
    if self.persisted? && self.name_changed?
      msg = Message.new(:division_renamed)
      msg.data[:division_id] = self.id
      msg.data[:division_name] = self.name
      msg.data[:division_slug] = self.slug
      enqueue_message msg
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  def default_season
    self.current_season ? self.current_season : seasons.desc(:starts_on).first
  end

 
end

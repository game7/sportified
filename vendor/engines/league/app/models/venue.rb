class Venue
  include Mongoid::Document
  include Sportified::SiteContext
  include Sportified::PublishesMessages

  field :name
  validates_presence_of :name

  field :short_name

  before_save :ensure_short_name
  def ensure_short_name
    if short_name.nil? || short_name.empty?
      self.short_name = name
    end
  end

  def renamed?
    name_changed? || short_name_changed?
  end

  before_save :prepare_renamed_message
  def prepare_renamed_message
    if renamed?
      msg = Message.new(:venue_renamed)
      msg.data[:venue_id] = id
      msg.data[:new_venue_name] = name
      msg.data[:new_venue_short_name] = short_name
    end
    enqueue_message msg
  end

end

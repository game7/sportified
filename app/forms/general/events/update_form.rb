class General::Events::UpdateForm
  include ActiveModel::Model
  include Virtus::Model

  attribute :id, Integer
  attribute :starts_on, DateTime
  attribute :duration, Integer
  attribute :all_day, Boolean, default: false
  attribute :location_id, Integer
  attribute :page_id, Integer
  attribute :summary, String
  attribute :description, String
  attribute :tag_list, String

  def initialize(event)
    @event = event
    assign_attributes event.attributes.slice(*self.attributes.stringify_keys.keys)
    self.tag_list = event.tag_list
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'General::Event')
  end

  def persisted?
    true
  end

  def audits
    @event.audits
  end

  validates_presence_of :starts_on,
                        :duration,
                        :location_id,
                        :summary


  def submit(params)
    assign_attributes(whitelist(params))
    return false unless valid?
    @event.update_attributes(self.attributes)
    @event.save
  end

  def whitelist(params)
    Chronic.time_class = Time.zone
    params[:general_event][:starts_on] = Chronic.parse(params[:general_event][:starts_on])
    params.require(:general_event)
          .permit(:program_id, :starts_on, :duration, :page_id, :all_day, :location_id, :summary, :description, :tag_list)
  end

end

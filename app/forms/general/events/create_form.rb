class General::Events::CreateForm
  include ActiveModel::Model
  include Virtus::Model

  attribute :starts_on, DateTime
  attribute :duration, Integer
  attribute :all_day, Boolean, default: false
  attribute :location_id, Integer
  attribute :page_id, Integer
  attribute :summary, String
  attribute :description, String

  def initialize(event)
    @event = event
    self.attributes.keys
    assign_attributes event.attributes.slice(*self.attributes.keys)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'General::Event')
  end

  def persisted?
    false
  end

  validates_presence_of :starts_on,
                        :duration,
                        :location_id,
                        :page_id,
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
          .permit(:program_id, :starts_on, :duration, :page_id, :all_day, :location_id, :summary, :description)
  end

end

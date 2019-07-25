class Admin::Events::AssignForm
  include ActiveModel::Model
  include Virtus::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Event')
  end

  class EventForm
    include ActiveModel::Model
    include Virtus::Model

    attribute :home_team_name, String
    attribute :away_team_name, String
    attribute :home_team_locker_room_id, Integer
    attribute :away_team_locker_room_id, Integer

    def initialize(event, locker_rooms)
      @event = event
      @locker_rooms = locker_rooms
      self.home_team_name = event.home_team_name
      self.away_team_name = event.away_team_name
      self.home_team_locker_room_id = event.home_team_locker_room_id
      self.away_team_locker_room_id = event.away_team_locker_room_id
    end

    def id
      @event.id
    end

    def starts_on
      @event.starts_on.strftime("%l:%M%P").gsub("m","")
    end

    def summary
      @event.summary
    end

    def locker_rooms
      @locker_rooms
    end

    def model_name
      model.model_name
    end

    def persisted?
      true
    end

    def save
      @event.update_attributes(self.attributes)
    end

  end

  attribute :id, Integer
  attribute :date, Date

  def initialize(date)
    @date = date
    locker_rooms = LockerRoom.order(:name).group_by(&:location_id)
    @events = Event.after(date.beginning_of_day)
                   .before(date.end_of_day)
                   .order(:starts_on)
                   .collect{|e| EventForm.new(e, locker_rooms[e.location_id])}
  end

  def submit(params)
    assign_attributes(params.require(:event).permit!)
    @events.each(&:save)
    true
  end

  def events
    @events
  end

  def date
    @date
  end

  def date_display
    @date.today? ? 'Today' : @date.strftime('%A %b %-d')
  end

  def events_attributes=(attributes)
    @events ||= []
    attributes.each do |i, event_params|
      @events[i.to_i].assign_attributes(event_params.except('id'))
    end
  end

end

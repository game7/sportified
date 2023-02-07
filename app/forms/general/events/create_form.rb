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
  attribute :tag_list, String
  attribute :private, Boolean

  attribute :repeat, Boolean
  attribute :repeat_on_sunday, Boolean
  attribute :repeat_on_monday, Boolean
  attribute :repeat_on_tuesday, Boolean
  attribute :repeat_on_wednesday, Boolean
  attribute :repeat_on_thursday, Boolean
  attribute :repeat_on_friday, Boolean
  attribute :repeat_on_saturday, Boolean
  attribute :ends, String, default: 'date'
  attribute :ends_on, Date
  attribute :ends_after_occurrences, Integer

  def initialize(event)
    @event = event
    assign_attributes event.attributes.slice(*attributes.keys.collect(&:to_s))
    self.repeat = false
    self.ends = 'on'
    self.ends_after_occurrences = 10
    self.tag_list = event.tag_list
    self.location_id = location_options[0][1] if location_options.length == 1
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
                        :summary

  validates :ends_on, presence: { if: :repeating_with_end_date? }
  validates :ends_after_occurrences, presence: { if: :repeating_with_occurances? },
                                     numericality: { if: :repeating_with_occurances?,
                                                     only_integer: true }

  def repeating?
    repeat == true
  end

  def repeating_with_end_date?
    repeat == true and ends == 'on'
  end

  def repeating_with_occurances?
    repeat == true and ends == 'after'
  end

  def submit(params)
    assign_attributes(whitelist(params))
    return false unless valid?

    Event.transaction do
      @event.update_attributes(attributes.slice(:starts_on, :duration, :location_id, :page_id, :summary, :tag_list,
                                                :private))
      @event.save
      if repeating?
        schedule = IceCube::Schedule.new(now = @event.starts_on + 1.day) do |schedule|
          schedule.add_recurrence_rule IceCube::Rule.weekly.day(*repeat_days)
        end
        slots = if ends == 'after'
                  schedule.first(ends_after_occurrences - 1)
                else
                  schedule.occurrences(Chronic.parse(ends_on).end_of_day)
                end
        slots.each do |slot|
          recurrence = @event.dup
          date = Time.zone.local(
            slot.year,
            slot.month,
            slot.day,
            recurrence.starts_on.hour,
            recurrence.starts_on.min
          )
          recurrence.starts_on = date
          recurrence.save
        end
      end
    end
    true
  end

  def whitelist(params)
    Chronic.time_class = Time.zone
    params[:general_event][:starts_on] = Chronic.parse(params[:general_event][:starts_on])
    params[:general_event][:ends_on] = Chronic.parse(params[:general_event][:ends_on])
    params.require(:general_event)
          .permit(*attributes.keys.concat([tag_list: []]))
  end

  def repeat_days
    Date::DAYNAMES.collect(&:downcase)
                  .select { |day| send("repeat_on_#{day}") }
                  .collect(&:to_sym)
  end

  def self.repeat_interval_options
    %w[week]
  end

  def self.ends_options
    %w[on after]
  end

  def location_options
    @location_options ||= Location.order(:name).pluck(:name, :id)
  end
end

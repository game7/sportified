class Next::Admin::Events::CalendarController < Next::Admin::BaseController
  def index
    respond_to do |format|
      format.html do
        inertia props: {
          date: date,
          events: events(date).as_json(include: %i[location program tags], methods: [:type], except: :tag_list),
          locations: Location.select(:id, :name, :color).order(name: :asc).as_json,
          tags: ActsAsTaggableOn::Tag.for_tenant(Tenant.current).order(name: :asc)
        }
      end
      format.csv { download(date) }
    end
  end

  private

  def date
    params[:date] ? Time.zone.parse(params[:date]) : Time.zone.today
  end

  def events(date)
    range = [date.beginning_of_month.beginning_of_day...date.end_of_month.end_of_day]
    Event.includes(:location, :program, :tags)
         .where(starts_on: range)
         .order(:starts_on)
  end

  def download(date)
    send_data to_csv(events(date).includes(:location, :program, :tags)), filename: "events-#{date}.csv"
  end

  def to_csv(events)
    data = serialize(events)

    ::CSV.generate do |csv|
      csv << data[0].keys
      data.each { |row| csv << row.values }
    end
  end

  def serialize(events) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    events.map do |e|
      {
        'start date': e.starts_on.strftime('%a %-m/%-d/%Y'),
        'start time': e.starts_on.strftime('%l:%M %P'),
        'end date': e.ends_on.strftime('%a %-m/%-d/%Y'),
        'end time': e.ends_on.strftime('%l:%M %P'),
        duration: e.duration,
        summary: e.summary,
        location: e.location.name,
        'playing surface': e.try(:playing_surface).try(:name),
        'division': e.try(:division).try(:name),
        tags: e.tags.join(',')
      }
    end
  end
end

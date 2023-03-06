class Next::Admin::Events::PlannerController < Next::Admin::BaseController
  def index
    inertia props: {
      date: date,
      events: events(date).as_json(include: %i[location program tags], methods: [:type], except: :tag_list),
      locations: Location.order(name: :asc).as_json,
      tags: ActsAsTaggableOn::Tag.for_tenant(Tenant.current).order(name: :asc)
    }
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
end

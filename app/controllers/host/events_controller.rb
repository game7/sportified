class Host::EventsController < Host::BaseController
  def index
    date = params[:date] ? Time.zone.parse(params[:date]) : Time.zone.today

    inertia props: {
      date: date,
      tenants: tenants,
      events: events(date)
    }
  end

  def show
    event = Ahoy::Event.unscoped.includes(:visit, :user).find(params[:id])

    inertia props: {
      event: event
    }
  end

  private

  def events(date)
    Ahoy::Event.unscoped.includes(:visit, :user)
               .where(time: [date.beginning_of_day...(date.end_of_day)])
               .order(time: :asc)
  end

  def tenants
    Tenant.all.order(name: :asc)
  end
end

class League::ScheduleController < BaseLeagueController
  def index
    @events = @division.events.in_the_future.order(starts_on: :asc)
  end
end

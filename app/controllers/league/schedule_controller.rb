class League::ScheduleController < BaseLeagueController
  def index
    @events = @division.events.where('starts_on > ?', DateTime.now - 7.days).order(starts_on: :asc)
  end
end

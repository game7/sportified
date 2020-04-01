class League::ScheduleController < BaseLeagueController
  def index
    @events = League::Game.for_division(@division).in_the_future.order(starts_on: :asc)
  end
end

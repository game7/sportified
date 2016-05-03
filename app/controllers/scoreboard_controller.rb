class ScoreboardController < ::BaseLeagueController

  before_filter :get_dates
  def get_dates
    date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 0
    @days_in_past = 14
    @start_date = date - @days_in_past - 1
    @end_date = date + @days_in_future + 1
    @next_date = date + @days_in_future + @days_in_past
    @prev_date = date - @days_in_future - @days_in_past
  end

  def index

    @games = League::Game.where('starts_on > ? AND ends_on < ?', @start_date, @end_date)
                  .includes(:home_team, :away_team, :statsheet)
                  .order(starts_on: :asc)

    @games = @games.for_division(League::Division.with_slug(params[:division_slug])) if params[:division_slug]

    @days = @games.group_by{|game| game.starts_on.to_date.strftime("%A, %B %e %Y")}

  end

end

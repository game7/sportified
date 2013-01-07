class ScoreboardController < BaseLeagueController
  
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
    
    add_breadcrumb("Scoreboard")
    
    @games = Game.gt(starts_on: @start_date).lt(ends_on: @end_date)
    @games = @games.for_league(@league) if @league
    @games = @games.desc(:starts_on).entries

  end

end

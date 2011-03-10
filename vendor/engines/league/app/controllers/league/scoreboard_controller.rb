class League::ScoreboardController < League::BaseDivisionController
  
  before_filter :get_dates

  def set_breadcrumbs
    super
    add_new_breadcrumb "Scoreboard"
  end

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
    @games = Game.between(@start_date, @end_date)
    @games = @games.for_division(@division) if @division
    @games = @games.desc(:starts_on).entries
  end

end

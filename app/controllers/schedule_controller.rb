class ScheduleController < BaseLeagueController

  def index
    
    add_breadcrumb("Schedule")
    
    if params[:season_slug]
      add_breadcrumb(@season.name)
      @events = @league.events.for_season(@season).asc(:starts_on)
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 0
      @start_date = @date - @days_in_past
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
      @events = @league.events.between(@start_date, @end_date)
      @events = @events.asc(:starts_on).entries
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

end

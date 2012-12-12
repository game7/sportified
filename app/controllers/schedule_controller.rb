class ScheduleController < BaseLeagueController
  before_filter :get_team_options
  
  def index
    
    add_breadcrumb("Schedule")
    
    if params[:season_slug]
      add_breadcrumb(@season.name)
      @events = @league.events.for_season(@season).asc(:starts_on)
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 0
      @start_date = @date - @days_in_past - 1
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
  
  private
  
  def get_team_options
    @team_options = @league.teams.for_season(@season).asc(:name).collect{|t| [t.name, team_schedule_path(:league_slug => t.league_slug, :season_slug => t.season_slug, :team_slug => t.slug)]}
    @team_options.insert 0, ["Team Schedules", ""]
  end  

end

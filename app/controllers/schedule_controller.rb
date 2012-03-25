class ScheduleController < BaseLeagueController
  before_filter :get_season_links
  before_filter :get_team_schedule_links


  def index
    
    add_breadcrumb("Schedule")
    
    if params[:season_slug]
      add_breadcrumb(@season.name)
      @events = @league.events.for_season(@season).asc(:starts_on)
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 7
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

  def get_season_links
    @season_links = @league.seasons.desc(:starts_on).each.collect{ |s| [s.name, schedule_path(@league.slug, s.slug)] }
    @season_links.insert(0, ['All Seasons', schedule_path(@league.slug)])
  end

  def get_team_schedule_links
    teams = @league.teams.for_season(@season).asc(:name)
    @team_schedule_links = teams.each.collect do |t|
      [t.name, "#"]#team_schedule_path(division.slug, season.slug, t.slug)] 
    end   
  end 

end

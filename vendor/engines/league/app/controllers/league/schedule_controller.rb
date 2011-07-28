class League::ScheduleController < League::BaseDivisionController

  def links_to_division()
    links = Division.for_site(Site.current).asc(:name).each.collect{ |d| [d.name + " Division", league_schedule_path(d.slug)] }
    links.insert(0, ['All Divisions', league_schedule_path])
  end

  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def set_breadcrumbs
    super
    add_breadcrumb "Schedule"
  end

  def index
    @division_links = links_to_division
    @team_links = links_to_team_schedule(@division, @division.default_season) if @division
    
    if params[:season_slug]
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @events = @division.games.for_season(@season).asc(:starts_on)
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 7
      @start_date = @date - @days_in_past - 1
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
      @events = Event.for_site(Site.current).between(@start_date, @end_date)
      @events = @events.for_division(@division) if @division
      @events = @events.asc(:starts_on).entries
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

end

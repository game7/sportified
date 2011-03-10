class League::ScheduleController < League::BaseDivisionController

  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_friendly_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def set_breadcrumbs
    super
    add_new_breadcrumb "Schedule"
  end

  # GET /games
  # GET /games.xml
  def index

    @team_links = links_to_team_schedule(@division, @season) if @division
    
    if params[:season_slug]
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @games = @division.games.for_season(@season).asc(:starts_on)
      if params[:team_slug]
        @team = @season.teams.with_slug(params[:team_slug])
        @games = @games.for_team(@team.id)
      end
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 7
      @start_date = @date - @days_in_past - 1
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
      @games = Game.between(@start_date, @end_date)
      @games = @games.for_division(@division) if @division
      @games = @games.asc(:starts_on).entries
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

end

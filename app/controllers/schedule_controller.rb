class ScheduleController < BaseLeagueController
  before_filter :get_team_options, :unless => :all_leagues?

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
      @events = all_leagues? ? Event : @league.events
      @events = @events.includes(:location)
      @events = @events.where('starts_on > ? AND ends_on < ?', @start_date, @end_date).order(starts_on: :asc)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games.entries }
    end
  end

  private

  def all_leagues?
    !@league
  end

  def get_team_options
    @team_options = @league.teams.for_season(@season).order(:name).collect{|t| [t.name, team_schedule_path(:league_slug => t.league.slug, :season_slug => t.season.slug, :team_slug => t.slug)]}
    @team_options.insert 0, ["Team Schedules", ""]
  end

end

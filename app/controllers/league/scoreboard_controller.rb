class League::ScoreboardController < League::BaseDivisionController
  
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

  def set_breadcrumbs
    super
    add_breadcrumb "Scoreboard"
  end

  def links_to_division()
    links = Division.for_site(Site.current).asc(:name).each.collect{ |d| [d.name + " Division", league_scoreboard_path(d.slug)] }
    links.insert(0, ['All Divisions', league_scoreboard_path])
  end


  def index
    
    @division_links = links_to_division

    @games = Game.for_site(Site.current).between(@start_date, @end_date)
    @games = @games.for_division(@division) if @division
    @games = @games.desc(:starts_on).entries

  end

end

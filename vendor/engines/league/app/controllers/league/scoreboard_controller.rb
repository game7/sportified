class League::ScoreboardController < League::BaseDivisionController
  
  before_filter :load_for_division

  def load_for_division
    
    @division = Division.with_slug(params[:division_slug]).first 

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)

    load_area_navigation @division
 
  end

  def index
    
    if params[:season_slug]
      @season = @division.seasons.with_slug(params[:season_slug]).first
      @games = @division.games.for_season(@season).desc(:starts_on).entries
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 0
      @days_in_past = 14
      @start_date = @date - @days_in_past - 1
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
      @games = Game.between(@start_date, @end_date).for_division(@division).desc(:starts_on).entries
    end

  end

end

class Admin::GamesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit]
  
  before_filter :add_games_breadcrumb
  def add_games_breadcrumb
    add_breadcrumb 'Games', admin_games_path  
  end
  
  before_filter :load_season_options, :only => [:index, :new, :edit]
  def load_season_options
    @seasons = Season.for_site(Site.current).desc(:starts_on).entries
  end
  
  before_filter :load_division_options, :only => [:index, :new, :edit]
  def load_division_options
    @divisions = Division.for_site(Site.current).asc(:name).entries
  end

  before_filter :load_venue_options, :only => [:new, :edit]
  def load_venue_options
    @venues = Venue.for_site(Site.current).asc(:name).entries
  end

  before_filter :load_team_options, :only => [:new, :edit]
  def load_team_options
    @teams = Team.for_site(Site.current).asc(:name).entries.collect do |team|
      [ "#{team.name} (#{team.division_name} Division)", team.id ]
    end
  end

  before_filter :load_game, :only => [:show, :edit, :destroy, :transition]
  def load_game
    @game = Game.for_site(Site.current).find(params[:id])  
  end
  
  before_filter :load_division, :only => [:index]
  def load_division
    @division = Division.for_site(Site.current).find(params[:division_id]) if params[:division_id]
  end
  
  before_filter :load_season, :only => [:index]
  def load_season
    @season = Season.for_site(Site.current).find(params[:season_id]) if params[:season_id]    
  end

  before_filter :load_games, :only => [:index]
  def load_games
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 14
    @days_in_past = 7
    @start_date = @date - @days_in_past - 1
    @end_date = @date + @days_in_future + 1
    @next_date = @date + @days_in_future + @days_in_past
    @prev_date = @date - @days_in_future - @days_in_past

    @games = Game.for_site(Site.current)    
    @games = @games.for_division(@division) if @division
    @games = @games.for_season(@season) if @season
    @games = @games.between(@start_date, @end_date) unless @division.present? || @season.present?
    @games = @games.asc(:starts_on)    
  end

  def index
  end

  def new
    @game = Game.new
    @game.season_id = params[:season_id]
    @game.venue_id = @venues[0].id if @venues.count
  end

  def edit
  end

  def create
    @game = Game.new(params[:game])
    @game.site = Site.current
    if @game.save
      return_to_last_point(:notice => 'Game was successfully created.')
    else
      load_season_options
      load_team_options
      load_venue_options
      load_division_options
      render :action => "new"
    end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      return_to_last_point(:notice => 'Game was successfully updated.')
    else
      load_season_options
      load_team_options
      load_venue_options     
      load_division_options
      render :action => "edit"
    end
  end

end

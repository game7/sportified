class Admin::Games::ResultsController < Admin::BaseLeagueController
  
  before_filter :find_game, :only => [:new, :create, :destroy]
  before_filter :find_season, :only => [:index]
  before_filter :get_season_links, :only => [:index]
  before_filter :get_league_links, :only => [:index]    
  
  def index
    @games = Game.includes(:statsheet).for_season(@season).in_the_past.desc(:starts_on)
    @games = @games.for_league(params[:league_id]) if params[:league_id]
  end

  def new
    current = @game.result.clone if @game.result
    @result = @game.build_result
    if current
      puts @result.home_score = current.home_score
      puts @result.away_score = current.away_score
      puts @result.completed_in = current.completed_in
    end 
  end

  def create
    @result = @game.build_result(params[:game_result])
    if @game.save
      flash[:success] = "Game Result has been posted."
    else
      flash[:error] = "Game Result could not be posted."
    end  
  end
  
  private
  
  def find_game
    @game = Game.find(params[:game_id])
  end
  
  def find_season
    @season = Season.find(params[:season_id]) if params[:season_id]
    @season ||= Season.most_recent()    
  end
  
  def get_season_links
    @season_links = Season.all.desc(:starts_on).each.collect do |s|
      [s.name, admin_game_results_path(:season_id => s.id)]
    end
  end
  
  def get_league_links
    @league_links = @season.leagues.asc(:name).each.collect do |l|
      [l.name, admin_game_results_path(:season_id => @season.id, :league_id => l.id)]
    end
    @league_links.insert 0, ["All Leagues", admin_game_results_path(:season_id => @season.id)]
  end
  
end

class Admin::StatsheetsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:edit]
  before_filter :find_game
  before_filter :find_season
  before_filter :add_games_breadcrumb
  before_filter :add_stats_breadcrumb

  def show

  end

  def edit
    unless @game.has_statsheet?
      @statsheet = Hockey::Statsheet.new
      @statsheet.game = @game
      @statsheet.save
    else
      @statsheet = @game.statsheet
    end
  end

  private

  def find_game
    @game = Game.find(params[:game_id])    
  end
  
  def find_season
    @season = @game.season    
  end

  def add_games_breadcrumb
    add_breadcrumb 'Games', admin_games_path  
  end

  def add_stats_breadcrumb
    add_breadcrumb 'Statsheet'  
  end  


end

class Admin::StatsheetsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :destroy]
  before_filter :load_game
  before_filter :get_season

  def load_game
    @game = Game.for_site(Site.current).find(params[:game_id])    
  end
  
  def get_season
    @season = @game.season    
  end

  def show

  end

  def edit
    unless @game.has_statsheet?
      @statsheet = HockeyStatsheet.new
      @game.statsheet = @statsheet
      @statsheet.save
      @game.save
    else
      @statsheet = @game.statsheet
    end
  end



end

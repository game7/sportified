class StatisticsController < BaseLeagueController
  
  def index   
    add_breadcrumb "Statistics"
    add_breadcrumb @season.name if @season
    
    @season_options = @league.seasons.all.desc(:starts_on).collect{|s| [s.name, statistics_path(:league_slug => @league.slug, :season_slug => s.slug)]}    
    
    limit = 3
    @goal_leaders = Player.for_league(@league).for_season(@season).where(:"record.g".gt => 0).desc("record.g").limit(limit)
    @assist_leaders = Player.for_league(@league).for_season(@season).where(:"record.a".gt => 0).desc("record.a").limit(limit)
    @point_leaders = Player.for_league(@league).for_season(@season).where(:"record.pts".gt => 0).desc("record.pts").limit(limit)
    @savepct_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_gp".gt => 0).desc("record.g_svp").limit(limit)
    @save_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_gp".gt => 0).desc("record.g_sv").limit(limit)
    @shutout_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_so".gt => 0).desc("record.g_so").limit(limit)
    @hattrick_leaders = Player.for_league(@league).for_season(@season).where(:"record.hat".gt => 0).desc("record.hat").limit(limit)
    @playmaker_leaders = Player.for_league(@league).for_season(@season).where(:"record.plmkr".gt => 0).desc("record.plmkr").limit(limit)
    @gordie_leaders = Player.for_league(@league).for_season(@season).where(:"record.gordie".gt => 0).desc("record.gordie").limit(limit)
  end  
  
  def show
    @view = params[:view]
    
    @season_options = @league.seasons.all.desc(:starts_on).collect{|s| [s.name, statistic_path(:league_slug => @league.slug, :season_slug => s.slug, :view => @view)]}    
        
    @token = params[:token] || Hockey::Player::Record.default_token(params[:view])    
    @players = Player.for_league(@league).for_season(@season).desc("record."+@token).limit(25)
    
    # let's only show goalies in the goaltender view
    @players = @players.where(:"record.g_gp".gt => 0) if params[:view] == "goaltending"

  end
  
  private

  def set_breadcrumbs
    super
  end 

end

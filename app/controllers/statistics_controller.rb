class StatisticsController < BaseLeagueController
  before_filter :get_season_options
  
  def index   
    add_breadcrumb "Statistics"
    add_breadcrumb @season.name if @season
    
    limit = 3
    @goal_leaders = Player.for_league(@league).for_season(@season).where(:"record.g".gt => 0).desc("record.g").limit(limit)
    @assist_leaders = Player.for_league(@league).for_season(@season).where(:"record.a".gt => 0).desc("record.a").limit(limit)
    @point_leaders = Player.for_league(@league).for_season(@season).where(:"record.pts".gt => 0).desc("record.pts").limit(limit)
    @savepct_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_gp".gt => 0).desc("record.g_svp").limit(limit)
    @save_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_gp".gt => 0).desc("record.g_sv").limit(limit)
    @shutout_leaders = Player.for_league(@league).for_season(@season).where(:"record.g_so".gt => 0).desc("record.g_so").limit(limit)
  end  
  
  private
  
  def get_season_options
    @season_options = Season.all.desc(:starts_on).collect{|s| [s.name, statistics_path(:league_slug => @league.slug, :season_slug => s == @season ? nil : s.slug)]}
  end  

  def set_breadcrumbs
    super
  end 

end

class PlayersController < BaseLeagueController
  before_filter :get_season_options
  
  def index

    @teams = @league.teams.for_season(@season)
    ids = @teams.collect{|team| team.id}
    @players = Player.where(:team_id.in => ids).asc(:last_name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end
  
  private
  
  def get_season_options
    @season_options = Season.all.desc(:starts_on).collect{|s| [s.name, players_path(:league_slug => @league.slug, :season_slug => s.slug)]}
  end

end

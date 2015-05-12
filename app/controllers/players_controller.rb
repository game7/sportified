class PlayersController < BaseLeagueController
  before_filter :get_season_options, :only => [:index]
  
  def index

    @teams = @league.teams.for_season(@season)
    ids = @teams.collect{|team| team.id}
    @players = Player.joins(:team).where('teams.season_id = ?', @season.id).order(last_name: :asc)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end
  
  def show

    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @player }
    end
    
  end  
  
  private
  
  def get_season_options
    @season_options = @league.seasons.all.order(starts_on: :desc).collect{|s| [s.name, players_path(:league_slug => @league.slug, :season_slug => s.slug)]}
  end

end

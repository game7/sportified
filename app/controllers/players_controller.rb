class PlayersController < BaseLeagueController

  def index

    @teams = @league.teams.for_season(@season)
    ids = @teams.collect{|team| team.id}
    @players = Player.where(:team_id.in => ids).asc(:last_name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end


end

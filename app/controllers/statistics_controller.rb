class StatisticsController < BaseLeagueController

  def index
    add_breadcrumb "Statistics"
    add_breadcrumb @season.name if @season

    @season_options = @division.seasons.all.order(starts_on: :desc).collect{|s| [s.name, league_statistics_path(@program.slug, @division.slug, s.slug)]}

    limit = 3
    @goal_leaders = skaters(:goals, 3)
    @assist_leaders = skaters(:assists, 3)
    @point_leaders = skaters(:points, 3)
    @savepct_leaders = goalies(:save_percentage, 3)
    @save_leaders = goalies(:saves, 3)
    @shutout_leaders = goalies(:shutouts, 3)
    @hattrick_leaders = skaters(:hat_tricks, 3)
    @playmaker_leaders = skaters(:playmakers, 3)
    @gordie_leaders = skaters(:gordie_howes, 3)
  end

  def show
    @view = params[:view]
    @season_options = @division.seasons.all.order(starts_on: :desc).collect{|s| [s.name, league_statistic_path(@program.slug, @division.slug, s.slug, @view)]}

    @token = params[:token] || Hockey::Player::Record.default_token(params[:view])
    @players = (@view == 'goaltending') ? goalies(@token, 25) : skaters(@token, 25)

  end

  private

  def skaters(stat, limit)
    Hockey::Skater::Record.joins(player: :team).includes(:player).where('league_teams.division_id = ? AND league_teams.season_id = ?', @division.id, @season.id).where("hockey_skaters.#{stat} > 0").order(stat => :desc).limit(limit)
  end

  def goalies(stat, limit)
    Hockey::Goaltender::Record.joins(player: :team).includes(:player, :team).where('league_teams.division_id = ? AND league_teams.season_id = ?', @division.id, @season.id).where("hockey_goaltenders.#{stat} > 0").order(stat => :desc)
  end

  def set_breadcrumbs
    super
  end

end

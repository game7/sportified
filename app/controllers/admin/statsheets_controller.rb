class Admin::StatsheetsController < Admin::BaseLeagueController
  layout "print", :only => [:print]
  before_filter :mark_return_point, :only => [:edit]
  before_filter :find_game
  before_filter :find_season
  before_filter :find_or_build_statsheet, :only => [:edit, :print]
  before_filter :add_games_breadcrumb
  before_filter :add_stats_breadcrumb

  def edit

  end

  def print

  end

  private

  def find_or_build_statsheet
    unless @game.has_statsheet?
      @statsheet = Hockey::Statsheet.new
      @statsheet.game = @game
      @statsheet.save
      @statsheet.load_players
    else
      @statsheet = @game.statsheet
    end
  end

  def find_game
    @game = ::League::Game.find(params[:game_id])
  end

  def find_season
    @season = @game.season
  end

  def add_games_breadcrumb
    add_breadcrumb 'Events', admin_events_path
  end

  def add_stats_breadcrumb
    add_breadcrumb 'Statsheet'
  end


end

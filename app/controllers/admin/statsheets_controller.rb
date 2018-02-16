class Admin::StatsheetsController < Admin::BaseLeagueController
  layout :resolve_layout
  before_action :mark_return_point, only: :edit
  before_action :find_game
  before_action :find_season
  before_action :find_or_build_statsheet, only: [:edit, :print]
  before_action :add_games_breadcrumb
  before_action :add_stats_breadcrumb

  def edit

  end

  def print

  end

  private

    def resolve_layout
      case action_name
        when 'print'
          'print'
        else
          'admin'
      end
    end

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

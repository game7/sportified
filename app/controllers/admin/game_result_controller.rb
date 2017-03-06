class Admin::GameResultController < Admin::BaseLeagueController

  before_action :find_game, :only => [:edit, :result, :update]

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      flash[:success] = "Game Result has been posted."
    else
      flash[:error] = "Game Result could not be posted."
    end
  end

  private

  def game_params
    params.require(:game).permit(:away_team_score, :home_team_score, :completion, :result, :exclude_from_team_records)
  end

  def find_game
    @game = ::League::Game.find(params[:game_id])
  end

end

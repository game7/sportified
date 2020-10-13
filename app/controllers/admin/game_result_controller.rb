class Admin::GameResultController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations
  before_action :set_game, :only => [:edit, :update]
  before_action :mark_return_point, :only => :edit

  def edit
    add_breadcrumb 'Result'
  end

  def update
    if @form.submit(game_params)
      flash[:success] = "Game Result has been posted."
      redirect_to return_url
    else
      flash[:error] = "Game Result could not be posted."
      render :edit
    end
  end

  private

  def game_params
    params.require(:league_game).permit(:away_team_score, :home_team_score, :completion, :result, :exclude_from_team_records)
  end

  def set_game
    @game = ::League::Game.find(params[:game_id])
    @form = ::EditGameResultForm.new @game
  end


end

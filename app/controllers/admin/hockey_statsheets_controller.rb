class Admin::HockeyStatsheetsController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations

  before_action :mark_return_point, only: [:edit]
  before_action :load_statsheet

  def edit
    @partial = "admin/hockey_statsheets/#{params['form']}_form.html.haml"
    @title = params['title']
  end

  def update
    if @statsheet.update(hockey_statsheet_params)
      respond_to do |format|
        format.html do
          flash[:notice] = 'Statsheet Updated'
          render "admin/hockey_statsheets/update_#{params['form']}" if params['form']
        end
        format.json { render json: @statsheet }
      end
    else
      format.json { render json: @statsheet.errors, status: :unprocessable_entity }
    end
  end

  def post
    Hockey::Statsheet::Processor.post @statsheet
    flash[:success] = 'Statsheet Posted'
    redirect_to edit_admin_game_statsheet_path(@statsheet.game, return_to: return_url)
  end

  def unpost
    Hockey::Statsheet::Processor.unpost @statsheet
    flash[:success] = 'Statsheet Unposted'
    redirect_to edit_admin_game_statsheet_path(@statsheet.game, return_to: return_url)
  end

  private

  def hockey_statsheet_params
    params.required(:hockey_statsheet).permit(:min_1, :min_2, :min_3, :min_ot,
                                              :away_shots_1, :away_shots_2, :away_shots_3, :away_shots_ot,
                                              :home_shots_1, :home_shots_2, :home_shots_3, :home_shots_ot,
                                              :away_goals_1, :away_goals_2, :away_goals_3, :away_goals_ot,
                                              :home_goals_1, :home_goals_2, :home_goals_3, :home_goals_ot)
  end

  def load_statsheet
    @statsheet = Hockey::Statsheet.find(params['id'])
  end
end

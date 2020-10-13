class Admin::HockeyGoaltendersController < Admin::BaseLeagueController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations 
  before_action :find_statsheet
  before_action :find_goaltender, :only => [:edit, :update, :destroy]
  before_action :list_players, :only => [:new, :edit]

  def new
    @goaltender = @statsheet.goaltenders.build()
  end

  def edit
  end

  def update
    if @goaltender.update_attributes(hockey_goaltender_params)
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = "Goaltender Updated"
        end
        format.json  { render json: @goaltender }
      end
    else
      respond_to do |format|
        format.html do
          list_players
        end 
        format.json  { render json: @goaltender.errors, status: 422 }
      end  
    end     
  end

  def create
    @goaltender = @statsheet.goaltenders.build(hockey_goaltender_params)
    if @goaltender.save
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = "Goaltender Added"
        end
        format.json  { render json: @goaltender }
      end
    else
      respond_to do |format|
        format.html do
          list_players
        end 
        format.json  { render json: @goaltender.errors, status: 422 }
      end  
    end  
  end

  def destroy
    if @goaltender.delete
      respond_to do |format|
        format.html { flash[:notice] = "Goaltender has been deleted" }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { flash[:error] = "Goaltender could not be" }
        format.json { head :bad_request }
      end
    end
  end

  def autoload
    @statsheet.goaltenders.each(&:delete)
    @statsheet.autoload_goaltenders
    if @statsheet.save
      respond_to do |format|
        format.html do
          @statsheet.reload
          flash[:notice] = "Goaltenders Loaded."
        end
        format.json  { render json: @statsheet.goaltenders.reload }
      end      
    else
      respond_to do |format|
        format.html { flash[:error] = "Goaltenders could not be loaded." }
        format.json { head :bad_request }
      end
    end
  end

  private

  def hockey_goaltender_params
    params.required(:hockey_goaltender_result).permit(:team_id, :player_id, :minutes_played, :shots_against, :goals_against)
  end

  def find_statsheet
    @statsheet = Hockey::Statsheet.find(params['hockey_statsheet_id'])
  end

  def find_goaltender
    @goaltender = @statsheet.goaltenders.find(params['id'])
  end

  def list_players
    @players = @statsheet.skaters.playing.order(last_name: :asc)
  end


end

class Admin::ClubsController < Admin::BaseLeagueController
  before_action :mark_return_point, only: %i[new edit destroy]
  before_action :add_clubs_breadcrumb
  before_action :load_club, only: %i[show edit update destroy]

  def index
    @clubs = Club.order(:name)
  end

  def show; end

  def new
    @club = Club.new
    add_breadcrumb 'New'
  end

  def edit; end

  def create
    @club = Club.new(club_params)
    if @club.save
      return_to_last_point success: 'Club was successfully created.'
    else
      flash[:error] = 'Club could not be created'
      render action: 'new'
    end
  end

  def update
    if @club.update(club_params)
      return_to_last_point success: 'Club was successfully updated.'
    else
      flash[:error] = 'Club could not be updated'
      render action: 'edit'
    end
  end

  def destroy
    @club.destroy
    return_to_last_point success: 'Club has been deleted.'
  end

  private

  def club_params
    params.required(:club).permit(:name, :short_name)
  end

  def add_clubs_breadcrumb
    add_breadcrumb 'Clubs', admin_clubs_path
  end

  def load_club
    @club = Club.find(params[:id])
    add_breadcrumb @club.name
  end
end

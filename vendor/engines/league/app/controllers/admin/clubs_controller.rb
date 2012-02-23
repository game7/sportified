class Admin::ClubsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_clubs_breadcrumb
  before_filter :load_club, :only => [:show, :edit, :update, :destroy]

  def index
    @clubs = Club.asc(:name)
  end

  def show
  end

  def new
    @club = Club.new
    add_breadcrumb 'New'
  end

  def edit
  end

  def create
    @club = Club.new(params[:club])
    if @club.save
      return_to_last_point :success => 'Club was successfully created.'
    else
      flash[:error] = "Club could not be created"
      render :action => "new"
    end
  end

  def update
    if @club.update_attributes(params[:club])
      return_to_last_point :success => 'Club was successfully updated.'
    else
      flash[:error] = "Club could not be updated"
      render :action => "edit"
    end
  end

  def destroy
    @club.destroy
    return_to_last_point :success => 'Club has been deleted.'
  end
  
  private
  
  def add_clubs_breadcrumb
    add_breadcrumb 'Clubs', admin_clubs_path  
  end

  def load_club
    @club = Club.find(params[:id])
    add_breadcrumb @club.name
  end
  
end

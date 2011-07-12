class Admin::ClubsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]

  before_filter :add_clubs_breadcrumb
  def add_clubs_breadcrumb
    add_breadcrumb 'Clubs', admin_clubs_path  
  end

  before_filter :load_club, :only => [:show, :edit, :update, :destroy]
  def load_club
    @club = Club.for_site(Site.current).find(params[:id])
    add_breadcrumb @club.name
  end

  def index
    @clubs = Club.for_site(Site.current).asc(:name)
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
    @club.site = Site.current
    if @club.save
      return_to_last_point(:notice => 'Club was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @club.update_attributes(params[:club])
      return_to_last_point(:notice => 'Club was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @club.destroy
    return_to_last_point(:notice => 'Club has been deleted.')
  end
end

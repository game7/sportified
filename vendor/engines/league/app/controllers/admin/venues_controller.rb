class Admin::VenuesController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]

  before_filter :add_venues_breadcrumb
  def add_venues_breadcrumb
    add_breadcrumb 'Venues', admin_venues_path  
  end

  before_filter :load_venue, :only => [:show, :edit, :update, :destroy]
  def load_venue
    @venue = Venue.for_site(Site.current).find(params[:id])
    add_breadcrumb @venue.name
  end

  def index
    @venues = Venue.for_site(Site.current).asc(:name)
  end

  def show

  end

  def new
    @venue = Venue.new
    add_breadcrumb 'New'
  end

  def edit

  end

  def create
    @venue = Venue.new(params[:venue])
    @venue.site = Site.current
    if @venue.save
      return_to_last_point :success => 'Venue was successfully created.'
    else
      flash[:error] = "Venue could not be created"
      render :action => "new"
    end
  end

  def update
    if @venue.update_attributes(params[:venue])
      return_to_last_point :success => 'Venue was successfully updated.'
    else
      flash[:error] = "Venue could not be updated"
      render :action => "edit"
    end
  end

  def destroy
    @venue.destroy
    return_to_last_point :success => 'Venue has been deleted.'
  end
end

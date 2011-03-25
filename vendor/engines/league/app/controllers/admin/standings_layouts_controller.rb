class Admin::StandingsLayoutsController < Admin::BaseLeagueController
  
  before_filter :add_standings_layout_breadcrumb
  before_filter :load_layout, :only => [:show, :edit, :update, :destroy, :columns]
  before_filter :load_layouts, :only => [:index]
  before_filter :mark_return_point, :only => [:new, :edit]

  def add_standings_layout_breadcrumb
    add_breadcrumb 'Standings Layout', admin_standings_layouts_path    
  end

  def load_layout
    @layout = StandingsLayout.for_site(Site.current).find(params[:id])  
    add_breadcrumb @layout.name
  end

  def load_layouts
    @layouts = StandingsLayout.for_site(Site.current).asc(:name)    
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def columns
    @columns = @layout.columns.asc(:order).entries

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @layout = StandingsLayout.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit

  end

  def create
    @layout = StandingsLayout.new(params[:standings_layout])
    @layout.site = Site.current

    respond_to do |format|
      if @layout.save
        format.html { return_to_last_point(:notice => 'Layout was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update

    respond_to do |format|
      if @layout.update_attributes(params[:standings_layout])
        format.html { return_to_last_point(:notice => 'Layout was successfully updated.') }
      else
        load_seasons
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @layout.destroy

    respond_to do |format|
      format.html { return_to_last_point(:notice => 'Layout has been deleted.') }
    end
  end
end

class Host::SitesController < Host::HostController
  
  before_filter :mark_return_point, :only => [:edit, :new, :destroy]
  before_filter :load_site, :only => [:edit, :update, :destroy]
  before_filter :get_themes, :only => [:new, :edit]

  def get_themes
    dir = "tmp/stylesheets/compiled/themes/"
    themes = Dir.glob(dir + "*")
    @themes = themes.collect{ |t| t.sub(dir, "") }
  end

  def load_site
    @site = Site.find(params[:id])
  end
  
  def set_breadcrumbs
    super
    add_breadcrumb( "Sites", host_sites_path )
  end

  def index
    @sites = Site.all.entries
  end  

  def edit
    
  end

  def new
    @site = Site.new
  end

  def update
    if @site.update_attributes(params[:site])
      return_to_last_point(:notice => 'Site has been updated.')
    else
      get_themes
      render :action => "edit"
    end
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      return_to_last_point(:notice => 'New Site has been created.')
    else
      get_themes
      render :action => "new"
    end
  end

  def destroy
    @site.destroy
    return_to_last_point(:notice => 'Site has been deleted.')
  end




end

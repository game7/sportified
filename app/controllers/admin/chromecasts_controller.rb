class Admin::ChromecastsController < Admin::AdminController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations  
  before_action :set_chromecast, only: [:edit, :update, :destroy]
  before_action :mark_return_point, only: [:new, :edit]

  layout 'admin'

  def index
    @chromecasts = Chromecast.order(:name).all
  end

  def new
    @chromecast = Chromecast.new
  end

  def create
    @chromecast = Chromecast.create chromecast_params
  end

  def edit
  end

  def update
    if @chromecast.update_attributes(chromecast_params)

    else

    end
  end

  def destroy
    @chromecast.destroy
  end

  def receive

  end

  private

    def set_chromecast
      @chromecast = Chromecast.find(params[:id])
    end

    def chromecast_params
      params.require(:chromecast).permit(:name, :location_id, :playing_surface_id)
    end

    def set_breadcrumbs
      super
      add_breadcrumb "Admin", admin_root_path
    end

end

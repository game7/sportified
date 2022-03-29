class Admin::ScreensController < Admin::AdminController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations  
  before_action :set_screen, only: [:edit, :update, :destroy]
  before_action :mark_return_point, only: [:new, :edit]

  layout 'admin'  

  def index
    @screens = Screen.order(:name).all
  end

  def new
    @screen = Screen.new
  end

  def create
    @screen = Screen.new screen_params
    if @screen.save
      redirect_to admin_screens_path, success: 'Screen has been created'
    else
      flash[:error] = "Screen could not be created"
      render :new      
    end       
  end

  def edit
  end

  def update
    if @screen.update_attributes screen_params
      redirect_to admin_screens_path, success: 'Screen has been updated'
    else

    end  
  end

  def destroy
    @screen.destroy
    redirect_to admin_screens_path, success: 'Screen has been deleted'
  end  

  private

    def set_screen
      @screen = Screen.find(params[:id])
    end

    def screen_params
      params.require(:screen).permit(:name, :device_key, :location_id, :playing_surface_id)
    end

  end

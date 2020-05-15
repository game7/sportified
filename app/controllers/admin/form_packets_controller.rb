class Admin::FormPacketsController < Admin::AdminController
  before_action :set_form_packet, only: [:show, :edit, :update, :destroy]
  before_action :mark_return_point, only: [:new, :edit, :destroy]

  layout 'admin'

  def index
    @form_packets = FormPacket.all
  end

  def show
  end

  def new
    add_breadcrumb 'New'
    @form_packet = FormPacket.new
  end

  def edit
    add_breadcrumb @form_packet.name
    add_breadcrumb 'Edit'
  end

  def create
    @form_packet = FormPacket.new(form_packet_params)

    if @form_packet.save
      redirect_to return_url, notice: 'Form packet was successfully created.'
    else
      render :new, error: 'Form packet could not be created.'
    end
  end

  def update
    if @form_packet.update(form_packet_params)
      redirect_to return_url, notice: 'Form packet was successfully updated.'
    else
      render :edit, error: 'Form packet could not be updated.'
    end
  end

  def destroy
    @form_packet.destroy
    redirect_to return_url, notice: 'Form packet was successfully destroyed.'
  end

  private

    def set_form_packet
      @form_packet = FormPacket.find(params[:id])
    end

    def form_packet_params
      params.require(:form_packet).permit(:name)
    end

    def set_breadcrumbs
      super
      add_breadcrumb 'Form Packets', admin_form_packets_path
    end  

end

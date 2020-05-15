class Admin::FormTemplatesController < Admin::AdminController
  before_action :set_form_template, only: [:show, :edit, :update, :destroy]
  before_action :set_form_packet, only: [:new, :create]
  before_action :mark_return_point, only: [:new, :edit, :destroy]

  def index
    @form_templates = FormTemplate.all
  end

  def show
  end

  def new
    @form_template = @form_packet.templates.build
  end

  def edit
  end

  def create
    @form_template = @form_packet.templates.build(form_template_params)
    @form_template.position = @form_packet.templates.length
    if @form_template.save
      redirect_to return_url, notice: 'Form template was successfully created.'
    else
      render :new
    end
  end

  def update
    if @form_template.update(form_template_params)
      redirect_to return_url, notice: 'Form template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @form_template.destroy
    redirect_to return_url, notice: 'Form template was successfully destroyed.'
  end

  private

    def set_form_template
      @form_template = FormTemplate.find(params[:id])
    end

    def set_form_packet
      @form_packet = FormPacket.find(params[:form_packet_id])
    end

    def form_template_params
      params.require(:form_template).permit(:name)
      # params.fetch(:form_template, {})
    end

    def set_breadcrumbs
      add_breadcrumb 'Forms'
      add_breadcrumb 'Form Packets', admin_form_packets_path
      add_breadcrumb @form_template.name if @form_template
      add_breadcrumb 'Templates'
    end  
end

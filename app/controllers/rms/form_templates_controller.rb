# == Schema Information
#
# Table name: rms_form_templates
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  packet_id  :integer
#  name       :string(40)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rms_form_templates_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (packet_id => rms_form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

require_dependency "rms/application_controller"

module Rms
  class FormTemplatesController < ApplicationController
    before_action :verify_admin
    before_action :set_form_template, only: [:show, :edit, :update, :destroy]
    before_action :set_form_packet, only: [:new, :create]
    before_action :mark_return_point, only: [:new, :edit, :destroy]


    # GET /form_templates
    def index
      @form_templates = FormTemplate.all
    end

    # GET /form_templates/1
    def show
    end

    # GET /form_templates/new
    def new
      @form_template = @form_packet.templates.build
    end

    # GET /form_templates/1/edit
    def edit
    end

    # POST /form_templates
    def create
      @form_template = @form_packet.templates.build(form_template_params)
      @form_template.position = @form_packet.templates.length
      if @form_template.save
        redirect_to return_url, notice: 'Form template was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /form_templates/1
    def update
      if @form_template.update(form_template_params)
        redirect_to return_url, notice: 'Form template was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /form_templates/1
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
        add_breadcrumb 'Form Packets', form_packets_path
        add_breadcrumb @form_template.name if @form_template
        add_breadcrumb 'Templates'
      end
  end
end

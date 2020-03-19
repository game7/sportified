# == Schema Information
#
# Table name: rms_form_packets
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(40)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rms_form_packets_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

require_dependency "rms/application_controller"

module Rms
  class FormPacketsController < ApplicationController
    before_action :verify_admin
    before_action :set_form_packet, only: [:show, :edit, :update, :destroy]
    before_action :mark_return_point, only: [:new, :edit, :destroy]

    layout 'admin'

    # GET /form_packets
    def index
      @form_packets = FormPacket.all
    end

    # GET /form_packets/1
    def show
    end

    # GET /form_packets/new
    def new
      add_breadcrumb 'New'
      @form_packet = FormPacket.new
    end

    # GET /form_packets/1/edit
    def edit
      add_breadcrumb @form_packet.name
      add_breadcrumb 'Edit'
    end

    # POST /form_packets
    def create
      @form_packet = FormPacket.new(form_packet_params)

      if @form_packet.save
        redirect_to return_url, notice: 'Form packet was successfully created.'
      else
        render :new, error: 'Form packet could not be created.'
      end
    end

    # PATCH/PUT /form_packets/1
    def update
      if @form_packet.update(form_packet_params)
        redirect_to return_url, notice: 'Form packet was successfully updated.'
      else
        render :edit, error: 'Form packet could not be updated.'
      end
    end

    # DELETE /form_packets/1
    def destroy
      @form_packet.destroy
      redirect_to return_url, notice: 'Form packet was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_form_packet
        @form_packet = FormPacket.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def form_packet_params
        params.require(:form_packet).permit(:name)
      end

      def set_breadcrumbs
        add_breadcrumb 'Forms'
        add_breadcrumb 'Form Packets', form_packets_path
      end
  end
end

# == Schema Information
#
# Table name: rms_forms
#
#  id              :integer          not null, primary key
#  tenant_id       :integer
#  registration_id :integer
#  template_id     :integer
#  data            :hstore
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  completed       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_rms_forms_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => rms_registrations.id)
#  fk_rails_...  (template_id => rms_form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

require_dependency "rms/application_controller"

module Rms
  class FormsController < ApplicationController
    before_action :verify_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy]

    layout 'admin'

    # GET /forms
    def index
      @forms = Form.all
    end

    # GET /forms/1
    def show
    end

    # GET /forms/new
    def new
      @form = Form.new
    end

    # GET /forms/1/edit
    def edit
    end

    # POST /forms
    def create
      @form = Form.new(form_params)

      if @form.save
        redirect_to @form, notice: 'Form was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /forms/1
    def update
      if @form.update(form_params)
        redirect_to @form, notice: 'Form was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /forms/1
    def destroy
      @form.destroy
      redirect_to forms_url, notice: 'Form was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_form
        @form = Form.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def form_params
        params.require(:form).permit(:name, :tenant_id)
      end
  end
end

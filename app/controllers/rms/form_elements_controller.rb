# == Schema Information
#
# Table name: rms_form_elements
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  template_id :integer
#  type        :string
#  name        :string(40)
#  position    :integer
#  properties  :hstore
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  required    :boolean
#  hint        :string
#
# Indexes
#
#  index_rms_form_elements_on_template_id_and_name  (template_id,name) UNIQUE
#  index_rms_form_elements_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => rms_form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

require_dependency "rms/application_controller"

module Rms
  class FormElementsController < ApplicationController
    before_action :verify_admin
    before_action :set_template, only: [:new, :create]
    before_action :set_element, only: [:edit, :update, :destroy]
    before_action :mark_return_point, only: [:new, :edit, :destroy]

    layout 'admin'

    def new
      @element = @template.elements.build(type: "Rms::FormElements::#{params[:type].classify}")
    end

    def create
      @element = @template.elements.build(element_params)
      @element.position = @template.elements.count + 1 unless @element.position.present?
      if @element.save
        redirect_to @template, notice: 'Form Element was successfully created.'
      else
        flash[:error] = "Form Element could not be created"
        render :new
      end
    end

    def edit
    end

    def update
      if @element.update_attributes(element_params)
        redirect_to @element.template, notice: 'Form Element was successfully updated.'
      else
        flash[:error] = "Form Element could not be updated"
        render :edit
      end
    end

    def destroy
      @element.destroy
      redirect_to @element.template, notice: 'Element was successfully deleted.'
    end

    private

      def element_params
        params.require(:form_element).permit!
      end

      def set_template
        @template = FormTemplate.find(params[:form_template_id])
      end

      def set_element
        @element = FormElement.find(params[:id])
      end

  end
end

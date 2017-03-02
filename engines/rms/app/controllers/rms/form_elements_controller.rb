require_dependency "rms/application_controller"

module Rms
  class FormElementsController < ApplicationController
    before_action :mark_return_point, only: [:new, :edit]

    def new
      render locals: {
        template: template,
        element: template.elements.build(type: element_type)
      }
    end

    def create
      element = template.elements.build(element_params)
      if element.save
        redirect_to template, notice: 'Form Element was successfully created.'
      else
        puts element.errors.messages
        flash[:error] = "Form Element could not be created"
        render :new
      end
    end

    def edit
      render locals: {
        template: nil,
        element: element
      }
    end

    def update

    end

    private

      def element_params
        params.require(:form_element).permit!
      end

      def element_type
        "Rms::FormElements::#{params[:type].classify}"
      end

      def template
        FormTemplate.find(params[:form_template_id])
      end

      def element
        FormElement.find(params[:id])
      end

  end
end

require_dependency "rms/application_controller"

module Rms
  class FormTemplatesController < ApplicationController
    before_action :set_form_template, only: [:show, :edit, :update, :destroy]

    # GET /form_templates
    def index
      @form_templates = FormTemplate.all
    end

    # GET /form_templates/1
    def show
    end

    # GET /form_templates/new
    def new
      @form_template = FormTemplate.new
    end

    # GET /form_templates/1/edit
    def edit
    end

    # POST /form_templates
    def create
      @form_template = FormTemplate.new(form_template_params)

      if @form_template.save
        redirect_to @form_template, notice: 'Form template was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /form_templates/1
    def update
      if @form_template.update(form_template_params)
        redirect_to @form_template, notice: 'Form template was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /form_templates/1
    def destroy
      @form_template.destroy
      redirect_to form_templates_url, notice: 'Form template was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_form_template
        @form_template = FormTemplate.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def form_template_params
        params.fetch(:form_template, {})
      end
  end
end

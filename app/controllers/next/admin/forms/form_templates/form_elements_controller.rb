class Next::Admin::Forms::FormTemplates::FormElementsController < Next::Admin::BaseController
  def order
    template = FormTemplate.find(params[:form_template_id])

    template.elements.each do |element|
      next if params[:ids].exclude? element.id

      element.update position: params[:ids].index(element.id)
    end

    redirect_back_or_to next_admin_forms_form_template_path(template)
  end
end

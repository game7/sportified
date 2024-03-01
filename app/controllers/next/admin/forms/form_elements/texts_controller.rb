class Next::Admin::Forms::FormElements::TextsController < Next::Admin::BaseController
  def update
    element = FormElements::Text.find(params[:id])

    if element.update(form_element_params)
      redirect_back_or_to next_admin_forms_form_template_path(element.template),
                          success: 'Event was successfully created.'
    else
      redirect_back_or_to next_admin_forms_form_template_path(element.template), inertia: { errors: element.errors }
    end
  end

  private

  def form_element_params
    params.require(:form_element).permit(:name, :required, :pattern, :message)
  end
end
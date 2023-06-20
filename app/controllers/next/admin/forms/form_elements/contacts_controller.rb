class Next::Admin::Forms::FormElements::ContactsController < Next::Admin::BaseController
  def update
    element = FormElements::Contact.find(params[:id])

    if element.update(form_element_params)
      redirect_back_or_to next_admin_forms_form_template_path(element.template),
                          success: 'Contact element has been updated'
    else
      redirect_back_or_to next_admin_forms_form_template_path(element.template), inertia: { errors: element.errors }
    end
  end

  private

  def form_element_params
    params.require(:form_element).permit(:name, :required)
  end
end

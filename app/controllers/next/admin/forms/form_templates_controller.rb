class Next::Admin::Forms::FormTemplatesController < Next::Admin::BaseController
  def show
    template = FormTemplate.find(params[:id])

    inertia props: {
      template: template,
      packet: template.packet,
      elements: template.elements
    }
  end
end

class Admin::FormElementsController < Admin::AdminController
  before_action :set_template, only: %i[new create]
  before_action :set_element, only: %i[edit update destroy]
  before_action :mark_return_point, only: %i[new edit destroy]

  def new
    @element = @template.elements.build(type: "FormElements::#{params[:type].classify}")
  end

  def create
    @element = @template.elements.build(element_params)
    @element.position = @template.elements.count + 1 unless @element.position.present?
    if @element.save
      redirect_to [:admin, @template], notice: 'Form Element was successfully created.'
    else
      flash[:error] = 'Form Element could not be created'
      render :new
    end
  end

  def edit; end

  def update
    if @element.update(element_params)
      redirect_to [:admin, @element.template], notice: 'Form Element was successfully updated.'
    else
      flash[:error] = 'Form Element could not be updated'
      render :edit
    end
  end

  def destroy
    @element.destroy
    redirect_to [:admin, @element.template], notice: 'Element was successfully deleted.'
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

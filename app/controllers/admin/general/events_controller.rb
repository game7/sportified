class Admin::General::EventsController < Admin::AdminController
  skip_before_action :verify_admin, only: [:show]
  before_action :verify_admin_or_operations, only: [:show] 
  before_action :load_event, :only => [:show, :edit, :update]
  before_action :mark_return_point, only: [:new, :edit]

  def show
    @recent_events_with_products = General::Event.with_product.order(starts_on: :desc).includes(:product).limit(10)
  end

  def new
    if params[:clone]
      original = ::General::Event.find(params[:clone])
      @event = original.dup
      @event.tag_list = original.tag_list
    else
      @event = ::General::Event.new
    end
    @form = ::General::Events::CreateForm.new @event
  end

  def create
    @form = ::General::Events::CreateForm.new ::General::Event.new
    if @form.submit(params)
      return_to_last_point :success => 'Event was successfully created.'
    else
      flash[:error] = 'Event could not be created.'
      render :action => :new
    end
  end


  def edit
    @form = ::General::Events::UpdateForm.new @event
  end

  def update
    @form = ::General::Events::UpdateForm.new @event
    if @form.submit(params)
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      flash[:error] = 'Event could not be updated.'
      render :action => :edit
    end
  end

  private

    def load_event
      @event = ::General::Event.find(params[:id])
    end

end

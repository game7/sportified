class Admin::General::EventsController < ApplicationController
  before_action :load_event, :only => [:edit, :update]
  before_action :mark_return_point, only: [:new, :edit]
  before_action :load_options, only: [:new, :create, :edit, :update]

  def new
    if params[:clone]
      @event = ::General::Event.find(params[:clone]).dup
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
      load_options
      render :action => :edit
    end
  end

  private

    def load_options
      @options = {
        pages: Page.options,
        programs: [],
        locations: Location.order(:name).pluck(:name, :id)
      }
    end

    def load_event
      @event = ::General::Event.find(params[:id])
    end

end

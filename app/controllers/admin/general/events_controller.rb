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
  end

  def create
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    @event = ::General::Event.new(event_params)
    if @event.save
      return_to_last_point :success => 'Event was successfully created.'
    else
      flash[:error] = 'Event could not be created.'
      render :action => :new
    end
  end


  def edit
  end

  def update
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    puts "(#{params[:event][:starts_on]})"
    if @event.update_attributes(event_params)
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      flash[:error] = 'Event could not be updated.'
      load_options
      render :action => :edit
    end
  end

  private

    def event_params
      params.require(:event).permit(:program_id, :starts_on, :duration, :page_id,
                                    :all_day, :location_id, :summary, :description)
    end

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

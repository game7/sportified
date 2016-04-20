class Admin::League::EventsController < ApplicationController
  before_filter :mark_return_point, :only => [:new, :edit]
  before_filter :load_event, :only => [:edit, :update, :destroy]
  before_filter :load_options, :only => [:new, :edit]

  def new
    if params[:clone]
      clone = ::League::Event.find(params[:clone])
      @event = clone.dup
    else
      @event = ::League::Event.new
      @event.program_id = @options[:programs].first.id if @options[:programs].length == 1
      @event.location_id = @options[:locations].first.id if @options[:locations].length == 1
    end
  end

  def create
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    @event = ::League::Event.new(event_params)
    if @event.save
      return_to_last_point :success => 'Event was successfully created.'
    else
      flash[:error] = 'Event could not be created.'
      load_options
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @event = ::League::Event.find(params[:id])
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    if @event.update_attributes(event_params)
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      flash[:error] = 'Event could not be updated.'
      load_options
      render :action => "edit"
    end
  end

  private

  def event_params
    params.require(:event).permit(:program_id, :season_id, :division_id, :starts_on, :duration,
      :all_day, :location_id, :summary, :description, :show_for_all_teams
    )
  end

  def load_options
    @options = {
      programs: ::League::Program.order(:name).select(:id, :name),
      divisions: ::League::Division.order(:name).select(:id, :name, :program_id).group_by{|d| d.program_id},
      seasons: ::League::Season.order(:name).select(:id, :name, :program_id).group_by{|s| s.program_id},
      locations: Location.order(:name).select(:id, :name)
    }
  end

  def load_event
    @event = ::League::Event.find(params[:id])
  end

end

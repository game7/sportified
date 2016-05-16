class Admin::Activity::SessionsController < ApplicationController
  before_filter :mark_return_point, :only => [:new, :edit]
  before_filter :load_session, :only => [:edit, :update, :destroy]
  before_filter :load_options, :only => [:new, :create, :edit, :update]

  def new
    if params[:clone]
      clone = ::Activity::Session.find(params[:clone])
      @session = clone.dup
    else
      @session = ::Activity::Session.new
      @session.program_id = @options[:programs].first.id if @options[:programs].length == 1
      @session.location_id = @options[:locations].first.id if @options[:locations].length == 1
    end
  end

  def create
    Chronic.time_class = Time.zone
    params[:session][:starts_on] = Chronic.parse(params[:session][:starts_on])
    @session = ::Activity::Session.new(session_params)
    if @session.save
      return_to_last_point :success => 'Session was successfully created.'
    else
      flash[:error] = 'Session could not be created.'
      render :action => "new"
    end
  end

  def edit

  end

  def update
    @session = ::Activity::Session.find(params[:id])
    Chronic.time_class = Time.zone
    params[:session][:starts_on] = Chronic.parse(params[:session][:starts_on])
    if @session.update_attributes(session_params)
      return_to_last_point(:notice => 'Session was successfully updated.')
    else
      flash[:error] = 'Session could not be updated.'
      render :action => "edit"
    end
  end

  private

  def session_params
    params.require(:session).permit(:program_id, :starts_on, :duration,
      :all_day, :location_id, :summary, :description
    )
  end

  def load_session
    @session = ::Activity::Session.find(params[:id])
  end

  def load_options
    @options = {
      programs: ::Activity::Program.order(:name).select(:id, :name),
      locations: Location.order(:name).select(:id, :name)
    }
  end

end

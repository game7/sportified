class Api::EventsController < ApplicationController
  def index
    from = params[:from] ? Date.parse(params[:from]) : Date.current
    to = params[:to] ? Date.parse(params[:to]) : Date.current + 1.days
    events = Event.all.after(from).before(to).order(:starts_on)    
    respond_to do |format|
      format.json { render json: events }
    end      
  end
end

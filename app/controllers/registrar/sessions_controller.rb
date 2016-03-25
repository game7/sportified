class Registrar::SessionsController < ApplicationController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_action :set_registrar_session, only: [:show, :edit, :update, :destroy]

  # GET /registrar/sessions
  def index
    @registrar_sessions = Registrar::Session.all
  end

  # GET /registrar/sessions/1
  def show
  end

  # GET /registrar/sessions/new
  def new
    @registrar_session = Registrar::Session.new
  end

  # GET /registrar/sessions/1/edit
  def edit
  end

  # POST /registrar/sessions
  def create
    @registrar_session = Registrar::Session.new(registrar_session_params)

    if @registrar_session.save
      redirect_to @registrar_session, notice: 'Session was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /registrar/sessions/1
  def update
    if @registrar_session.update(registrar_session_params)
      redirect_to @registrar_session, notice: 'Session was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /registrar/sessions/1
  def destroy
    @registrar_session.destroy
    redirect_to registrar_sessions_url, notice: 'Session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registrar_session
      @registrar_session = Registrar::Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def registrar_session_params
      params[:registrar_session]
    end
end

class Registrar::RegistrationsController < ApplicationController
  before_action :verify_user
  before_action :set_registration, only: [ :show ]
  before_action :set_registration_type, only: [ :new, :create ]

  def index
    @registrations = current_user.registrations.includes(:registration_type, :registrable)
  end

  def new
    @registration = @registration_type.registrations.build
    @registration.first_name = current_user.first_name
    @registration.last_name = current_user.last_name
    @registration.email = current_user.email
    @registration.email_confirmation = current_user.email
  end

  def create
    @registration = @registration_type.registrations.build(registration_params)
    @registration.user = current_user
    if @registration.save
      flash[:success] = "Congratulations!  You are now registered for #{@registration.registrable.title}"
      redirect_to [:registrar, @registration]
    else
      flash[:error] = "Registration could not be completed"
      render :new
    end
  end

  def show

  end

  private

  def registration_params
    params.require(:registration).permit(:first_name, :last_name, :email, :email_confirmation)
  end

  def set_registration_type
    @registration_type = Registrar::RegistrationType.find(params[:registration_type_id])
  end

  def set_registration
    @registration = Registrar::Registration.find(params[:id])
  end

end

# == Schema Information
#
# Table name: registrar_registrations
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  user_id              :integer
#  first_name           :string
#  last_name            :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  registration_type_id :integer
#  credit_card_id       :integer
#

class Registrar::RegistrationsController < ApplicationController
  before_action :verify_user

  def index
    @registrations = current_user.registrations.includes(:registration_type, :registrable)
  end

  def new
    registration = registration_type.registrations.build
    registration.first_name = current_user.first_name
    registration.last_name = current_user.last_name
    registration.email = current_user.email
    registration.email_confirmation = current_user.email
    registration.credit_card = credit_cards.last if registration.payment_required?
    render locals: {
      registration: registration,
      registration_type: registration_type,
      credit_cards: credit_cards,
      stripe_public_api_key: Tenant.current.stripe_public_api_key
    }
  end

  def create
    registration = registration_type.registrations.build(registration_params)
    registration.user = current_user
    if registration.save
      flash[:success] = "Congratulations!  You are now registered for #{registration.registrable.title}"
      redirect_to [:registrar, registration]
    else
      flash[:error] = "Registration could not be completed"
      render :new, locals: {
        registration: registration,
        registration_type: registration_type,
        credit_cards: credit_cards,
        stripe_public_api_key: Tenant.current.stripe_public_api_key
      }
    end
  end

  def show
    render locals: { registration: registration }
  end

  def payment
    render locals: { registration: registration, stripe_public_api_key: Tenant.current.stripe_public_api_key }
  end

  private

  def registration
    Registrar::Registration.find(params[:id])
  end

  def registration_type
    Registrar::RegistrationType.find(params[:registration_type_id])
  end

  def registration_params
    params.require(:registration).permit(:first_name, :last_name, :email, :email_confirmation, :credit_card_id)
  end

  def credit_cards
    current_user.credit_cards.entries << CreditCard.new
  end

end

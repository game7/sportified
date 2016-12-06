require_dependency "rms/application_controller"

module Rms
  class RegistrationsController < ApplicationController
    before_action :verify_user, only: [:index, :show]
    before_action :verify_admin, only: [:all]

    def index
      @registrations = current_user.registrations.includes(:item, :variant)
    end

    def all
      @registrations = Registration.includes(:item, :variant, :user).all.order("created_at DESC")
    end

    def new
      create and return if current_user
      render locals: {
        variant: variant,
        registration: variant.registrations.build
      }
    end

    def create
      registration = variant.registrations.build
      if current_user
        registration.user = current_user
        registration.email = current_user.email
        registration.first_name = current_user.first_name
        registration.last_name = current_user.last_name
      else
        registration.assign_attributes registration_params
      end

      if registration.save
        redirect_to checkout_registration_path registration
      else
        if(registration.errors[:email].blank?)
          if(user = User.where(email: registration.email).first)
            flash[:info] = "Welcome back #{user.first_name}.  Please sign in to continue your registration"
            store_location_for :user, new_variant_registration_path(variant)
            redirect_to main_app.new_user_session_path(email: registration.email) and return
          else
            flash[:success] = "Let's create your customer account"
            store_location_for :user, new_variant_registration_path(variant)
            redirect_to main_app.new_user_registration_path(email: registration.email) and return
          end
          render :new, locals: {
            registration: registration,
            variant: variant
          }
        else
          flash[:error] = "Registration could not be completed."
          render :new, locals: {
            registration: registration,
            variant: variant
          }
        end
      end
    end

    def show
      render locals: { registration: registration }
    end

    private

    def registration
      Registration.find_by!(id: params[:id], user_id: current_user.id)
    end

    def variant
      Variant.find(params[:variant_id])
    end

    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email)
    end

  end
end

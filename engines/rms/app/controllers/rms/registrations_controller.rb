require_dependency "rms/application_controller"

module Rms
  class RegistrationsController < ApplicationController
    around_action :set_time_zone
    before_action :verify_user, only: [:index, :show]
    before_action :verify_admin, only: [:all]

    def index
      @registrations = current_user.registrations.includes(:item, :variant).order("created_at DESC")
    end

    def all
      @registrations = Registration.includes(:item, :variant, :user).all.order("created_at DESC").page params[:page]
    end

    def new
      registration_attrs = {
        first_name: current_user.first_name,
        last_name: current_user.last_name
      }
      render locals: {
        variant: variant,
        registration: variant.registrations.build(registration_attrs)
      }
    end

    def create
      registration = variant.registrations.build(registration_params)
      if current_user
        registration.user = current_user
        registration.email = current_user.email
        variant.form_packet.templates.each do |template|
          registration.forms.build({ template: template, registration: registration })
        end if variant.form_packet
      else
        registration.assign_attributes registration_params
      end

      if registration.save
        redirect_to checkout_registration_path registration
      else
        if(!current_user and registration.errors[:email].blank?)
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
      where = { id: params[:id] }
      where[:user_id] = current_user.id unless current_user.host_or_admin?(Tenant.current.id)
      Registration.find_by!(where)
    end

    def variant
      Variant.find(params[:variant_id])
    end

    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :birthdate, :email)
    end

  end
end

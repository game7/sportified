require_dependency "rms/application_controller"

module Rms
  class RegistrationsController < ApplicationController
    before_action :verify_user

    def index
      @registrations = current_user.registrations.includes(:item, :variant)
    end

    def all
      @registrations = Registration.includes(:item, :variant, :user).all.order("created_at DESC")
    end

    def new
      registration = variant.registrations.build
      registration.first_name = current_user.first_name
      registration.last_name = current_user.last_name
      registration.email = current_user.email
      registration.email_confirmation = current_user.email
      registration.credit_card = credit_cards.last if registration.payment_required?
      registration.entry = variant.item.form.entries.build if registration.entry_required?
      render locals: {
        registration: registration,
        variant: variant,
        credit_cards: credit_cards,
        stripe_public_api_key: stripe_public_api_key
      }
    end

    def create
      registration = Registration.new
      registration.variant = variant
      registration.user = current_user
      registration.entry = variant.item.form.entries.build if registration.entry_required?
      registration.assign_attributes registration_params(form)

      if registration.save
        Stripe.api_key = Rms.configuration.stripe_private_key
        # begin
        if registration.payment_required?

          token = Stripe::Token.create(
            {
              :customer =>  current_user.stripe_customer_id
            },
            { :stripe_account => ::Tenant.current.stripe_account_id }
          )
          charge = Stripe::Charge.create({
                :amount => (registration.variant.price * 100).to_i,
                :currency => "usd",
                :source => token,
                :description => registration.item.title,
                :metadata => {
                  "registration_id" => "#{registration.id}",
                  "variant" => "#{registration.variant.title}"
                },
                :application_fee => 100
              },
              { :stripe_account => ::Tenant.current.stripe_account_id }
          )

          registration.payment_id = charge.id
          registration.save

        end
        # rescue
        #
        # end
        flash[:success] = "Congratulations!  You are now registered for #{registration.item.title}"
        redirect_to registration
      else
        flash[:error] = "Registration could not be completed."
        puts registration.errors.messages
        render :new, locals: {
          registration: registration,
          variant: variant,
          credit_cards: credit_cards,
          stripe_public_api_key: stripe_public_api_key
        }
      end
    end

    def show
      render locals: { registration: registration }
    end

    private

    def registration
      Registration.find(params[:id])
    end

    def stripe_public_api_key
      Rms.configuration.stripe_public_key
    end

    def variant
      Variant.find(params[:variant_id])
    end

    def form
      variant.item.form
    end

    def registration_params(form)
      params.require(:registration).permit(:first_name, :last_name, :email, :email_confirmation, :credit_card_id, :entry_attributes => form.permitted_params)
    end

    def credit_cards
      current_user.credit_cards.entries << ::CreditCard.new(id: "-1")
    end
  end
end

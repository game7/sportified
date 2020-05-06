require_dependency "rms/application_controller"

module Rms
  class CheckoutController < ApplicationController
    before_action :verify_user

    def redirect
      redirect_to_first_incomplete_form and return if registration.forms.incomplete.any?
      redirect_to_payment and return if registration.payment_required?
      redirect_to_confirmation
    end

    def form
      render locals: {
        registration: registration,
        form: get_form
      }
    end

    def submit
      form = get_form
      form.completed = true
      if form.update(form_params(form))
        redirect_to checkout_registration_path
      else
        render :form, locals: {
          registration: registration,
          form: form
        }
      end
    end

    def payment

      redirect_to checkout_registration_path(registration) and return unless registration.payment_required?

      render locals: {
        registration: registration,
        credit_cards: credit_cards,
        stripe_public_api_key: stripe_public_api_key
      }
    end

    def charge

      redirect_to checkout_registration_path(registration) and return unless registration.payment_required?

      Stripe.api_key = Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']

      customers = Stripe::Customer.list({ email: current_user.email, limit: 1 }, {
        stripe_account: Tenant.current.stripe_account_id
      })
      puts customer = customers['data'][0]

      args = {
        customer: (customer['id'] if customer),
        customer_email: (current_user.email unless customer),
        payment_method_types: ['card'],
        client_reference_id: registration.id,
        line_items: [
          {
            name: registration.item.title,
            description: "#{registration.item.title}: #{registration.variant.title}",
            images: [],
            amount: registration.price_in_cents,
            currency: 'usd',
            quantity: 1
          }
        ],
        payment_intent_data: {
          application_fee_amount: registration.application_fee_in_cents,
        },        
        # success_url: checkout_payment_registration_url(registration) + '?session_id={CHECKOUT_SESSION_ID}',
        success_url: confirm_registrations_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: checkout_payment_registration_url(registration)        
      }
      options = {
        stripe_account: Tenant.current.stripe_account_id
      }
      puts args
      puts options

      @session = Stripe::Checkout::Session.create args, options
      @stripe_public_api_key = stripe_public_api_key
      @stripe_account = Tenant.current.stripe_account_id

      puts @session

      registration.update(session_id: @session.id, payment_intent_id: @session.payment_intent)

      Stripe::PaymentIntent.update(@session.payment_intent, {
        description: "#{registration.item.title}: #{registration.variant.title}"
      }, {
        stripe_account: registration.tenant.stripe_account_id
      })

        # token = Stripe::Token.create(
        #   {
        #     :customer =>  current_user.stripe_customer_id,
        #     :card => registration.credit_card.stripe_card_id
        #   },
        #   { :stripe_account => ::Tenant.current.stripe_account_id }
        # )
        # begin
        #   # customer = Stripe::Customer.create({
        #   #     :source => token,
        #   #     :email => current_user.email,
        #   #     :description => current_user.full_name
        #   #   },
        #   #   { :stripe_account => ::Tenant.current.stripe_account_id }
        #   # )
        #   charge = Stripe::Charge.create({
        #         :amount => registration.price_in_cents,
        #         :currency => "usd",
        #         :customer => current_user.stripe_customer_id,
        #         :description => "#{registration.item.title}: #{registration.variant.title}",
        #         :metadata => {
        #           :registration_id => registration.id,
        #           :item => registration.item.title,
        #           :variant => registration.variant.title,
        #           :locator => registration.confirmation_code,
        #           :customer_name => registration.user.full_name,
        #           :customer_email => registration.user.email,
        #           :participant_name => registration.full_name
        #         },
        #         :application_fee => registration.application_fee_in_cents
        #       },
        #       { :stripe_account => ::Tenant.current.stripe_account_id }
        #   )
        #   registration.update({ payment_id: charge.id })
        # rescue Stripe::CardError => e
        #   flash[:error] = e.message
        # else
        #   RegistrationMailer.confirmation_email(Tenant.current, registration).deliver_now
        #   flash[:success] = "Payment has been processed.  You're Good!"
        #   redirect_to checkout_registration_path and return
        # end

      # end

      # render :payment, locals: {
      #   registration: registration,
      #   credit_cards: credit_cards,
      #   stripe_public_api_key: stripe_public_api_key
      # }
    end

    def confirmation
      render locals: {
        registration: registration,
        user: current_user
      }
    end

    private

      def registration
        @registration || @registration = Registration.find_by!(id: params[:id], user_id: current_user.id)
      end

      def credit_cards
        current_user.credit_cards.entries << ::CreditCard.new(id: "-1")
      end

      def stripe_public_api_key
        Tenant.current.stripe_public_key.presence || ENV['STRIPE_PUBLIC_KEY']
      end

      def get_form
        Form.find(params[:form_id]).add_element_accessors
      end

      def payment_params
        params.require(:registration).permit(:credit_card_id)
      end

      def form_params(form)
        params.require(:form).permit(form.template.permitted_params)
      end

      def redirect_to_first_incomplete_form
        redirect_to checkout_form_registration_path registration, registration.forms.incomplete.first
      end

      def redirect_to_payment
        redirect_to checkout_payment_registration_path registration
      end

      def redirect_to_confirmation
        redirect_to checkout_confirmation_registration_path registration
      end

  end
end

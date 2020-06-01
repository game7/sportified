# == Schema Information
#
# Table name: registrations
#
#  id                :integer          not null, primary key
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#  credit_card_id    :integer
#  first_name        :string(40)
#  last_name         :string(40)
#  email             :string
#  payment_id        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  price             :decimal(20, 4)
#  form_packet_id    :integer
#  confirmation_code :string
#  birthdate         :date
#  session_id        :text
#  payment_intent_id :text
#  uuid              :string
#
# Indexes
#
#  index_registrations_on_credit_card_id  (credit_card_id)
#  index_registrations_on_tenant_id       (tenant_id)
#  index_registrations_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_card_id => credit_cards.id)
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#

class RegistrationsController < ApplicationController
  before_action :verify_user, only: [:index]
  before_action :redirect_https

  def show
    render locals: { registration: Registration.find_by_uuid!(params[:id]) }
  end  

  def index
    @registrations = current_user.registrations.includes(:product, :variant).order("created_at DESC")
  end

  def new
    registration_attrs = {
      email: current_user&.email,
      first_name: current_user&.first_name,
      last_name: current_user&.last_name
    }
    registration = variant.registrations.build(registration_attrs)
    variant.form_packet.templates.each do |template|
      registration.forms.build({ template: template, registration: registration })
    end if variant.form_packet
    render locals: {
      variant: variant,
      registration: registration
    }
  end

  def create
      
    registration = variant.registrations.build(registration_params.except(:forms_attributes))
    
    # we have to build and initialize forms before assigning attributes so that the
    # dynamic setters and accessors can be created
    variant.form_packet.templates.each_with_index do |template, i|
      form = registration.forms.build({ template: template, registration: registration }).add_element_accessors
      form.completed = true
      form.assign_attributes(form_params[i.to_s].permit(template.permitted_params))
    end if variant.form_packet
    
    registration.user = current_user if current_user

    if registration.save
      redirect_to collect_registration_path(registration.uuid) if registration.payment_required?
      unless registration.payment_required?
        RegistrationMailer.confirmation_email(registration.id, registration_url(registration.uuid)).deliver_now
        redirect_to registration_path(registration.uuid) 
      end
    else
      flash[:error] = "Registration could not be completed"
      registration.errors[:base].each do |message|
        flash[:error] = message
      end
      render :new, locals: {
        registration: registration,
        variant: variant
      }
    end
  end
  

  def collect
    @registration = registration = Registration.find_by_uuid(params[:id])
    @stripe_public_api_key = stripe_public_api_key
    @stripe_account = Tenant.current.stripe_account_id   

    return if @registration.session_id.present?

    Stripe.api_key = Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']

    #  get existing customer for email address
    customers = Stripe::Customer.list({ email: registration.email, limit: 1 }, {
      stripe_account: Tenant.current.stripe_account_id
    })
    customer = customers['data'][0]

    session_params = {
      customer: (customer['id'] if customer),
      customer_email: (registration.email unless customer),
      payment_method_types: ['card'],
      client_reference_id: registration.id,
      line_items: [
        {
          name: registration.product.title,
          description: "#{registration.product.title}: #{registration.variant.title}",
          images: [],
          amount: registration.price_in_cents,
          currency: 'usd',
          quantity: 1
        }
      ],
      payment_intent_data: {
        application_fee_amount: registration.application_fee_in_cents,
      },        
      success_url: confirm_registration_url(registration.uuid),
      cancel_url: registration_url(registration.uuid)        
    }
    session_options = {
      stripe_account: Tenant.current.stripe_account_id
    }   
    
    session = Stripe::Checkout::Session.create session_params, session_options
    
    registration.update(session_id: session.id, payment_intent_id: session.payment_intent)

    Stripe::PaymentIntent.update(session.payment_intent, {
      description: "#{registration.product.title}: #{registration.variant.title}"
    }, {
      stripe_account: registration.tenant.stripe_account_id
    })      

  end


  def confirm

    registration = Registration.find_by_uuid(params[:id])

    Stripe.api_key = Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']
    
    payment_intent = Stripe::PaymentIntent.retrieve(registration.payment_intent_id, {
      stripe_account: registration.tenant.stripe_account_id
    })

    if payment_intent.status == 'succeeded'
      registration.update(payment_id: registration.payment_intent_id)
      RegistrationMailer.confirmation_email(registration.id, registration_url(registration.uuid)).deliver_now
      flash[:success] = "Payment has been processed"
      redirect_to registration_path(registration.uuid)    
    end
  end  


  private

    def variant
      Variant.find(params[:variant_id])
    end

    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :birthdate, :email)
    end

    def form_params
      params.require(:registration).fetch(:forms_attributes, {})
    end
    
    def stripe_public_api_key
      Tenant.current.stripe_public_key.presence || ENV['STRIPE_PUBLIC_KEY']
    end  

end

# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  user_id     :integer
#  brand       :string(20)
#  country     :string(2)
#  exp_month   :string(2)
#  exp_year    :string(4)
#  funding     :string(10)
#  last4       :string(4)
#  customer_id :integer
#  token_id    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CreditCardsController < ApplicationController

  def create
    credit_card = CreditCard.new(credit_card_params)
    credit_card.user = current_user

    Stripe::api_key = Tenant.current.stripe_secret_api_key

    customer = Stripe::Customer.create(
      :source      => credit_card.token_id,
      :description => "#{current_user.first_name} #{current_user.last_name}",
      :email       => current_user.email
    )
    credit_card.customer_id = customer.id
    if credit_card.save
      render json: credit_card, status: :ok
    else
      render json: Sportified::ErrorSerializer.serialize(credit_card.errors), status: :unprocessable_entity
    end
  end

  private

  def credit_card_params
    params.require(:credit_card).permit(:brand, :country, :exp_month, :exp_year, :funding, :last4, :token_id)
  end

end

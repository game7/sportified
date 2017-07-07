module Rms
  class Api::RegistrationSerializer < ActiveModel::Serializer

    type 'registration'

    attributes :id,
               :first_name,
               :last_name,
               :email,
               :birthdate,
               :price,
               :status,
               :payment_id,
               :forms,
               :created_at,
               :updated_at

    has_many :forms

    belongs_to :item
    belongs_to :variant

    def status
      object.payment_id.present? ? 'Completed' : 'Started'
    end

    def price
      object.price.to_f
    end

  end
end

class League::GameSerializer < ActiveModel::Serializer
    type :game
    attributes :id, :starts_on, :ends_on, :duration, :description, :summary
    has_one :program
    has_one :location
    has_one :division
    def id
      object.id.to_s
    end
  end
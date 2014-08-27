class EventSerializer < ActiveModel::Serializer
  attributes :id, :starts_on, :ends_on, :duration, :description, :summary
end

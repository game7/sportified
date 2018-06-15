class EventsResponseSerializer < ActiveModel::Serializer

  has_many :events, serializer: EventSerializer

end

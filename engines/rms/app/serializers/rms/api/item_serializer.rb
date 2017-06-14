module Rms
  class Api::ItemSerializer < ActiveModel::Serializer
    type 'item'
    attributes :id, :title
  end
end

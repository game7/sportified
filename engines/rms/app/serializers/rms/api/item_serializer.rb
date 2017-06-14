module Rms
  module Api
    class ItemSerializer < ActiveModel::Serializer
      type 'item'
      attributes :id, :title
    end
  end
end

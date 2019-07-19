module Rms
  class Api::FormSerializer < ActiveModel::Serializer
    type 'form'
    attributes :id, :data
  end
end

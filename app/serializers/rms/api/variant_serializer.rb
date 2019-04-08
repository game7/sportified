module Rms
  class Api::VariantSerializer < ActiveModel::Serializer
    type 'variant'
    attributes :id, :title, :description, :price
    belongs_to :item
  end
end

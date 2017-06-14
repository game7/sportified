module Rms
  class Api::Items::ShowSerializer < Api::ItemSerializer

    attributes :description

    has_many :variants
    has_many :registrations

  end
end

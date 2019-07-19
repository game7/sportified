module Rms
  module Api
    class Items::ShowSerializer < ItemSerializer

      attributes :description

      has_many :variants
      has_many :registrations

    end
  end
end

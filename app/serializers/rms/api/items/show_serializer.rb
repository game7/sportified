module Rms
  module Api
    module Items
      class ShowSerializer < ItemSerializer

        attributes :description

        has_many :variants
        has_many :registrations
      
      end
    end
  end
end

module League
  module Sides
    extend ActiveSupport::Concern

    SIDES = %w[left right]
    
    included do
      field :side
      validates_presence_of :side
      scope :left, :where => { :side => 'left' }
      scope :right, :where => { :side => 'right' }
      scope :for_side, lambda { |side| { :where => { :side => side } } }
    end

  end
end

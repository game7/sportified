module Statsheet::Sides
  extend ActiveSupport::Concern

  SIDES = %w[away home]

  included do
    field :side
    validates_presence_of :side
    scope :away, :where => { :side => 'away' }
    scope :home, :where => { :side => 'home' }
    scope :for_side, lambda { |side| { :where => { :side => side } } }
  end
end


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

    module ClassMethods
      def for_site(s)
        id = s.class == Site ? s.id : s
        where(:site_id => id)
      end      
    end 
  end
end

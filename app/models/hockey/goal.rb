module Hockey
  class Goal < Hockey::Event

    STR = %w[5-5 5-4 5-3 4-5 4-4 4-3 3-5 3-4 3-3 6-5 6-4 6-3]

    field :a1
    field :a2
    field :str, :default => '5-5'

    class << self
      def strengths
        STR
      end
    end

  end
end

module Hockey
  module Statsheet
    class Processor

      def self.post statsheet
        statsheet.players.each do |p|
          result = p.to_result
          player.record.post_result result
          player.save
        end
      end
  
      def self.unpost statsheet
        statsheet.players.each do |p|
          result = p.to_result
          player.record.cancel_result result
          player.save
        end          
      end
      
    end
  end
end
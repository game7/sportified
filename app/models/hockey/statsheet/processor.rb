module Hockey
  class Statsheet::Processor

    def self.post statsheet
      post_player_results statsheet
      set_to_posted statsheet
    end

    def self.unpost statsheet
      unpost_player_results statsheet
      set_to_unposted statsheet
    end

    private

    def self.post_player_results statsheet
      statsheet.skaters.each do |skater|
        if skater.player_id
          record = Hockey::Skater::Record.find_or_create_by(player_id: skater.player_id)
          record.add_result! skater
        end
      end
      statsheet.goaltenders.each do |goalie|
        if goalie.player_id
          record = Hockey::Goaltender::Record.find_or_create_by(player_id: goalie.player_id)
          record.add_result! goalie
        end
      end
    end

    def self.unpost_player_results statsheet
      statsheet.skaters.each do |skater|
        if skater.player_id
          if record = Hockey::Skater::Record.find_by(player_id: skater.player_id)
            record.remove_result! skater
          end
        end
      end
      statsheet.goaltenders.each do |goalie|
        if goalie.player_id
          if record = Hockey::Goaltender::Record.find_by(player_id: goalie.player_id)
            record.remove_result! goalie
          end
        end
      end
    end

    def self.set_to_posted statsheet
      statsheet.posted = true
      statsheet.save
    end

    def self.set_to_unposted statsheet
      statsheet.posted = false
      statsheet.save
    end

  end
end

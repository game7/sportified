class GameResult
  include Mongoid::Document
  include Mongoid::Timestamps

  COMPLETED_IN = %w[regulation overtime shootout forfeit]

  embedded_in :game, :inverse_of => :result
  
  field :completed_in
  field :left_team_score, :type => Integer
  field :right_team_score, :type => Integer
  field :internal_note, :default => ''

  after_create :raise_created_event
  after_destroy :raise_deleted_event

  private

    def raise_created_event
      @event = Event.new(:game_result_posted)
      @event.data[:game_id] = self.game.id
      EventBus.current.publish(@event)
    end

    def raise_deleted_event
      @event = Event.new(:game_result_deleted)
      @event.data[:game_id] = self.game.id
      EventBus.current.publish(@event)      
    end

end

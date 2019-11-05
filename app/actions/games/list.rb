class Games::List < Action

    def initialize(payload)
      @payload = payload
    end
  
    def call
      League::Game.before(1.day.from_now)
                  .includes(:division, :program, :location)
                  .order(starts_on: :desc)
                  .page(@payload[:page] || 0)
    end
  
  end
  
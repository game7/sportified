module EventBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :wait_for_events, :start, :purge, :stop, :to => :current

    def init
      EventBus.current = Rails.configuration.event_bus.constantize.new
      Rails.configuration.event_subscribers.each(&:constantize)
    end
  end
end

class InProcessEventBus
  def publish(event)
    subscriptions(event.name).each do |subscription|
      subscription.call(event)
    end
  end

  def events
    @subscriptions ||= Hash.new
    @subscriptions.keys || []
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name] ||= Set.new
  end

  def subscribe(event_name, &handler)
    subscriptions(event_name) << handler
  end

  def wait_for_events; end
  def purge; end
  def start; end
  def stop; end
end


module EventBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :wait_for_events, :start, :purge, :stop, :to => :current
  end
end

class InProcessEventBus
  def publish(event)
    subscriptions(event.name).each do |subscription|
      subscription.call(event)
    end
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

# specifiy event bus
EventBus.current = InProcessEventBus.new
# auto-subscribe handlers
TeamRecordManager

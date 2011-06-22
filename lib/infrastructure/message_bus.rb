module MessageBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :messages, :subscriptions, :wait_for_messages, :start, :purge, :stop, :to => :current

    def init
      MessageBus.current = Rails.configuration.message_bus.constantize.new
      Rails.configuration.message_subscribers.each(&:constantize)
    end
  end
end

class InProcessMessageBus
  
def publish(msg)
    subscriptions(msg.name).each do |subscription|
      subscription.call(msg)
    end
  end

  def subscribe(message_name, &handler)
    subscriptions(message_name) << handler
  end

  def messages
    @subscriptions ||= Hash.new
    @subscriptions.keys || []
  end

  def subscriptions(message_name)
    @subscriptions ||= Hash.new
    @subscriptions[message_name] ||= Set.new
  end

  def wait_for_messages; end
  def purge; end
  def start; end
  def stop; end
    
end


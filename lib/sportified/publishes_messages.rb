module Sportified
  module PublishesMessages
    extend ActiveSupport::Concern 
    
    def enqueue_message(message)
      @messages ||= []
      @messages << message      
    end

    def self.included(klass)
      klass.send :after_save, :publish_messages
    end

    def publish_messages
      while msg = @messages.shift do EventBus.current.publish(msg) end if @messages
    end

  end
end

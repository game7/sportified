module MessageHandler
  def on(*messages, &block)
    messages.each do |message_name|
      ::MessageBus.subscribe(message_name) do |msg|
        begin
          self.handling_message = true
          block.call(msg)
        ensure
          self.handling_message = false
        end
      end
    end
  end

  def handling_message?
    Thread.current["handling_message"]
  end

  def handling_message=(value)
    Thread.current["handling_message"] = value
  end
end

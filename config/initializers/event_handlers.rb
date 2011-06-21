# Force autoloading of Event Subscribers:

#EventBus.current = InProcessEventBus.new
#TeamRecordManager
#TeamNameManager
Rails.application.class.configure do
  config.event_bus = 'InProcessEventBus'
  config.event_subscribers = %w{TeamRecordManager TeamNameManager}
  config.to_prepare { EventBus.init }
end

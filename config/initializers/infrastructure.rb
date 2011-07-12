
Rails.application.class.configure do
  config.message_bus = 'InProcessMessageBus'
  config.message_subscribers = %w{TeamRecordManager TeamNameManager TeamLogoManager}
  config.to_prepare { MessageBus.init }
end

require Rails.root.join('config/environments/production')

Rails.application.configure do

  config.active_storage.service = :development

end

Rails.application.config.to_prepare do
  db = Rails.configuration.database_configuration[Rails.env].with_indifferent_access
  Blazer.settings['data_sources']['main']['url'] = [
    db[:adapter],
    '://',
    db[:username],
    ':',
    db[:password],
    '@',
    db[:host],
    ':',
    db[:port],
    '/',
    db[:database]
  ].join
end

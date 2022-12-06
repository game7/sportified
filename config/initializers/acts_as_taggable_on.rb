Rails.application.config.after_initialize do
  require_relative '../../app/models/acts_as_taggable_on/tag'
end

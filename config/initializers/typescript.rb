Rails.application.config.after_initialize do
  # notify of potential routing changes
  Typescript::Routes::Generator.notify_changes
end

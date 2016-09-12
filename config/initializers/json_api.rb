# ActiveModel::Serializer.config.adapter = ActiveModel::Serializer::Adapter::JsonApi
ActiveModel::Serializer.config.adapter = :json
ActiveModel::Serializer.config.key_transform = :camel_lower

# Mime::Type.register "application/json", :json, %w( text/x-json application/jsonrequest application/vnd.api+json )

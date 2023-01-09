# allow svg to be previewed
ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')

# use proxy routes
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy

# extend models
Rails.configuration.to_prepare do
  module ActiveStorageBlobSerialization # rubocop:disable Lint/ConstantDefinitionInBlock
    extend ActiveSupport::Concern

    def as_json(options)
      super(options).merge(url: Rails.application.routes.url_helpers.rails_blob_path(self, only_path: true),
                           signed_id: signed_id)
    end
  end

  ActiveStorage::Blob.prepend ActiveStorageBlobSerialization
end

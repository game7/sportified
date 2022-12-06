class ActiveStorage::BlobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    blob = ActiveStorage::Blob.create_after_upload!(
      io: attachable.open,
      filename: attachable.original_filename,
      content_type: attachable.content_type
      # service_name: :postgresql
    )
    extra = { url: Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true) }
    respond_to do |format|
      format.json { render json: blob.attributes.merge(extra) }
    end
  end

  private

  def attachable
    params.require(:blob)
  end
end

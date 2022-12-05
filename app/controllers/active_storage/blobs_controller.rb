class ActiveStorage::BlobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    blob = ActiveStorage::Blob.create_after_upload!(
      io: attachable.open,
      filename: attachable.original_filename,
      content_type: attachable.content_type
      # service_name: :postgresql
    )
    respond_to do |format|
      format.json { render json: blob }
    end
  end

  private

  def attachable
    params.require(:blob)
  end
end

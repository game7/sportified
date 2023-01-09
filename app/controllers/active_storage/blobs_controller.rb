class ActiveStorage::BlobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
    blobs = ActiveStorage::Blob.all
    respond_to do |format|
      format.json { render json: blobs.as_json(methods: [:image?]) }
    end
  end

  def create
    blob = ActiveStorage::Blob.create_and_upload!(
      io: attachable.open,
      filename: attachable.original_filename,
      content_type: attachable.content_type,
      service_name: :postgresql
    )
    respond_to do |format|
      format.json { render json: blob.as_json(methods: [:image?]) }
    end
  end

  private

  def attachable
    params.require(:blob)
  end
end

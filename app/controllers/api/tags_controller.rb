class Api::TagsController < ApplicationController
  def index
    tags = ActsAsTaggableOn::Tag.order(:name)
    render json: tags
  end

  def update
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    if tag.update(tag_params)
      render json: tag, status: :ok
    else
      render json: tag.errors.messages, status: :bad_request
    end
  end

  private

  def tag_params
    params.required(:tag).permit(:color)
  end
end

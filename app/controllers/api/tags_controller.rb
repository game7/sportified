class Api::TagsController < ApplicationController

  def index
    tags = ActsAsTaggableOn::Tag.order(:name)
    render json: tags
  end

end

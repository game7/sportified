class MarkdownController < ApplicationController
  respond_to :json

  def preview
    render json: {
      markdown: markdown_param,
      html: MarkdownService.html(markdown_param),
      toc: MarkdownService.table_of_contents(markdown_param)
    }, status: :ok
  end

  private

    def markdown_param
      params.permit(:markdown)[:markdown]
    end

end

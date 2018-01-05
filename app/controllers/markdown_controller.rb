class MarkdownController < ApplicationController
  respond_to :json

  def preview
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({
                                        with_toc_data: true,
                                        hard_wrap: true
                                       }),
                                       autolink: true,
                                       no_intra_emphasis: true,
                                       fenced_code_blocks: true,
                                       strikethrough: true,
                                       underline: true,
                                       highlight: true,
                                       quote: true,
                                       footnotes: true,
                                       tables: true)
    toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)

    render json: { markdown: markdown_param,
                   html: markdown.render(markdown_param),
                   toc: toc.render(markdown_param)}, status: :ok
  end

  private

    def markdown_param
      params.permit(:markdown)[:markdown]
    end

end

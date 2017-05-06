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

    render json: { markdown: markdown_params,
                   html: markdown.render(markdown_params),
                   toc: toc.render(markdown_params)}, status: :ok
  end

  private

    def markdown_params
      params.require(:markdown)
    end

end

class MarkdownService

  def self.html(markdown)
    return '' if markdown.blank?
    options = {
      with_toc_data: true,
      hard_wrap: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    extensions = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      strikethrough: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
      tables: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    redcarpet.render(markdown)
  end

  def self.table_of_contents(markdown)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC).render(markdown)
  end

end

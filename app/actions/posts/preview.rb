class Posts::Preview < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    {
      preview: MarkdownService.html(@payload.permit(:markdown)[:markdown])
    }
  end

end

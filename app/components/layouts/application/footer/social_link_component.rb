class Layouts::Application::Footer::SocialLinkComponent < ViewComponent::Base
  def initialize(url:, icon:, tagline:)
    @url = url
    @icon = icon
    @tagline = tagline
  end

  def render?
    @url.present?
  end

  def link
    helpers.link_to(helpers.brandify(@icon, @tagline), @url, { target: "_blank", title: @tagline })
  end
end

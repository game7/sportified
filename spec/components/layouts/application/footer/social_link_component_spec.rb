require "rails_helper"

RSpec.describe Layouts::Application::Footer::SocialLinkComponent, type: :component do
  it "renders something useful" do
    url = 'http://foobar.com'
    tagline = 'Foob us on Foobar!'
    expect(
      render_inline(described_class.new(url: url, icon: :foobar, tagline: tagline)) { "Hello, components!" }.to_html
    ).to include(
      tagline
    )
  end
end

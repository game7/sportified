require "rails_helper"

RSpec.describe Layouts::Application::FooterComponent, type: :component do
  it 'renders' do
    expect(
      render_inline(described_class.new(tenant: Tenant.new)).to_html
    ).not_to be_empty
  end

  it 'returns a twitter url' do
    handle = 'foobar'
    component = described_class.new(tenant: Tenant.new(twitter_id: handle))
    expect(component.twitter_url).to eq("https://twitter.com/#{handle}")
  end

  it 'returns no twitter_url when no twitter_id' do
    component = described_class.new(tenant: Tenant.new)
    expect(component.twitter_url).to be_nil
  end

end

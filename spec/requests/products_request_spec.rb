require 'rails_helper'

RSpec.describe "Products", type: :request do
  fixtures :tenants, :users

  before(:each) do
    tenant_scope tenants(:hockey_league_site)     
  end

  it 'should list products' do
    get products_path
    expect(response).to render_template(:index)
  end
end

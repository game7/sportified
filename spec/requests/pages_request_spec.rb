require 'rails_helper'

RSpec.describe "Pages", type: :request do  
  fixtures :tenants, :pages

  before(:each) do
    tenant_scope tenants(:hockey_league_site)     
  end

  it "sould get the home page" do
    get root_path
    assert_response :success
  end

  it "should get the contact us page" do
    get '/pages/about/contact-us'
    assert_response :success
  end

  it "should not the home page for paths that do not exist" do
    get '/pages/does-not-exist'
    assert_response :success
    assert_select 'title', "Welcome :: #{tenants(:hockey_league_site).name}"
  end

end

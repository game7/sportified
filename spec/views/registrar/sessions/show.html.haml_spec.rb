require 'rails_helper'

RSpec.describe "registrar/sessions/show", :type => :view do
  before(:each) do
    @registrar_session = assign(:registrar_session, Registrar::Session.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

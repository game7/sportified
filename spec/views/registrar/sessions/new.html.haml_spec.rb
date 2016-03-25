require 'rails_helper'

RSpec.describe "registrar/sessions/new", :type => :view do
  before(:each) do
    assign(:registrar_session, Registrar::Session.new())
  end

  it "renders new registrar_session form" do
    render

    assert_select "form[action=?][method=?]", registrar_sessions_path, "post" do
    end
  end
end

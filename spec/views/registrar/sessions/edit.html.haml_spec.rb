require 'rails_helper'

RSpec.describe "registrar/sessions/edit", :type => :view do
  before(:each) do
    @registrar_session = assign(:registrar_session, Registrar::Session.create!())
  end

  it "renders the edit registrar_session form" do
    render

    assert_select "form[action=?][method=?]", registrar_session_path(@registrar_session), "post" do
    end
  end
end

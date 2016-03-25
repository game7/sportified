require 'rails_helper'

RSpec.describe "registrar/sessions/index", :type => :view do
  before(:each) do
    assign(:registrar_sessions, [
      Registrar::Session.create!(),
      Registrar::Session.create!()
    ])
  end

  it "renders a list of registrar/sessions" do
    render
  end
end

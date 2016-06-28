require 'rails_helper'

RSpec.describe "registrar/registrables/edit", :type => :view do
  before(:each) do
    @registrar_registrable = assign(:registrar_registrable, Registrar::Registrable.create!())
  end

  it "renders the edit registrar_registrable form" do
    render

    assert_select "form[action=?][method=?]", registrar_registrable_path(@registrar_registrable), "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "registrar/registrables/new", :type => :view do
  before(:each) do
    assign(:registrar_registrable, Registrar::Registrable.new())
  end

  it "renders new registrar_registrable form" do
    render

    assert_select "form[action=?][method=?]", registrar_registrables_path, "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "registrar/registrables/show", :type => :view do
  before(:each) do
    @registrar_registrable = assign(:registrar_registrable, Registrar::Registrable.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

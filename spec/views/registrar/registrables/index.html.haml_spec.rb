require 'rails_helper'

RSpec.describe "registrar/registrables/index", :type => :view do
  before(:each) do
    assign(:registrar_registrables, [
      Registrar::Registrable.create!(),
      Registrar::Registrable.create!()
    ])
  end

  it "renders a list of registrar/registrables" do
    render
  end
end

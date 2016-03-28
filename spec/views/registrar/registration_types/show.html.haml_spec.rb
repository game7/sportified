require 'rails_helper'

RSpec.describe "registrar/registration_types/show", :type => :view do
  before(:each) do
    @registrar_registration_type = assign(:registrar_registration_type, Registrar::RegistrationType.create!(
      :session => nil,
      :title => "Title",
      :description => "MyText",
      :price => "9.99",
      :quantity_allowed => 1,
      :quantity_available => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end

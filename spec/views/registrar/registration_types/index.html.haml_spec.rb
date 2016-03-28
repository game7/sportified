require 'rails_helper'

RSpec.describe "registrar/registration_types/index", :type => :view do
  before(:each) do
    assign(:registrar_registration_types, [
      Registrar::RegistrationType.create!(
        :session => nil,
        :title => "Title",
        :description => "MyText",
        :price => "9.99",
        :quantity_allowed => 1,
        :quantity_available => 2
      ),
      Registrar::RegistrationType.create!(
        :session => nil,
        :title => "Title",
        :description => "MyText",
        :price => "9.99",
        :quantity_allowed => 1,
        :quantity_available => 2
      )
    ])
  end

  it "renders a list of registrar/registration_types" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end

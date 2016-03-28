require 'rails_helper'

RSpec.describe "registrar/registration_types/edit", :type => :view do
  before(:each) do
    @registrar_registration_type = assign(:registrar_registration_type, Registrar::RegistrationType.create!(
      :session => nil,
      :title => "MyString",
      :description => "MyText",
      :price => "9.99",
      :quantity_allowed => 1,
      :quantity_available => 1
    ))
  end

  it "renders the edit registrar_registration_type form" do
    render

    assert_select "form[action=?][method=?]", registrar_registration_type_path(@registrar_registration_type), "post" do

      assert_select "input#registrar_registration_type_session_id[name=?]", "registrar_registration_type[session_id]"

      assert_select "input#registrar_registration_type_title[name=?]", "registrar_registration_type[title]"

      assert_select "textarea#registrar_registration_type_description[name=?]", "registrar_registration_type[description]"

      assert_select "input#registrar_registration_type_price[name=?]", "registrar_registration_type[price]"

      assert_select "input#registrar_registration_type_quantity_allowed[name=?]", "registrar_registration_type[quantity_allowed]"

      assert_select "input#registrar_registration_type_quantity_available[name=?]", "registrar_registration_type[quantity_available]"
    end
  end
end

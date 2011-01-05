require 'spec_helper'

describe "sports/edit.html.erb" do
  before(:each) do
    @sport = assign(:sport, stub_model(Sport,
      :name => "MyString"
    ))
  end

  it "renders the edit sport form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sport_path(@sport), :method => "post" do
      assert_select "input#sport_name", :name => "sport[name]"
    end
  end
end

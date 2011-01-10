require 'spec_helper'

describe "divisions/edit.html.erb" do
  before(:each) do
    @division = assign(:division, stub_model(Division,
      :name => "MyString"
    ))
  end

  it "renders the edit division form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => division_path(@division), :method => "post" do
      assert_select "input#division_name", :name => "division[name]"
    end
  end
end

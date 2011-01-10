require 'spec_helper'

describe "seasons/new.html.erb" do
  before(:each) do
    assign(:season, stub_model(Season,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new season form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => seasons_path, :method => "post" do
      assert_select "input#season_name", :name => "season[name]"
    end
  end
end

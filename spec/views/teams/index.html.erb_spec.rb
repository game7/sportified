require 'spec_helper'

describe "teams/index.html.erb" do
  before(:each) do
    assign(:teams, [
      stub_model(Team,
        :string => "",
        :string => ""
      ),
      stub_model(Team,
        :string => "",
        :string => ""
      )
    ])
  end

  it "renders a list of teams" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end

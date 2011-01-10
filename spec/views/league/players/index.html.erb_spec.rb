require 'spec_helper'

describe "players/index.html.erb" do
  before(:each) do
    assign(:players, [
      stub_model(Player,
        :first_name => "First Name",
        :last_name => "Last Name",
        :jersey_number => "Jersey Number"
      ),
      stub_model(Player,
        :first_name => "First Name",
        :last_name => "Last Name",
        :jersey_number => "Jersey Number"
      )
    ])
  end

  it "renders a list of players" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Jersey Number".to_s, :count => 2
  end
end

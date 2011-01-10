require 'spec_helper'

describe "players/show.html.erb" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :first_name => "First Name",
      :last_name => "Last Name",
      :jersey_number => "Jersey Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Jersey Number/)
  end
end

require 'spec_helper'

describe "players/edit.html.erb" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :first_name => "MyString",
      :last_name => "MyString",
      :jersey_number => "MyString"
    ))
  end

  it "renders the edit player form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => player_path(@player), :method => "post" do
      assert_select "input#player_first_name", :name => "player[first_name]"
      assert_select "input#player_last_name", :name => "player[last_name]"
      assert_select "input#player_jersey_number", :name => "player[jersey_number]"
    end
  end
end

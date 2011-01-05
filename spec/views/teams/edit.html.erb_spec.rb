require 'spec_helper'

describe "teams/edit.html.erb" do
  before(:each) do
    @team = assign(:team, stub_model(Team,
      :string => "",
      :string => ""
    ))
  end

  it "renders the edit team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => team_path(@team), :method => "post" do
      assert_select "input#team_string", :name => "team[string]"
      assert_select "input#team_string", :name => "team[string]"
    end
  end
end

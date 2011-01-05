require 'spec_helper'

describe "games/edit.html.erb" do
  before(:each) do
    @game = assign(:game, stub_model(Game))
  end

  it "renders the edit game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => game_path(@game), :method => "post" do
    end
  end
end

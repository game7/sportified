require 'spec_helper'

describe GameUpload do
  
  before(:each) do
    @game_upload = GameUpload.make_unsaved
    @game_upload.contents = [1]
  end

  describe "validations" do
      
    it { should validate_presence_of(:contents) }
    it { should validate_presence_of(:season_id) }

    it "should otherwise be valid" do
      @game_upload.valid?.should == true
    end

  end

  describe "when mapping the uploaded file" do
    
    before(:each) do
      @game_upload.contents = file_data
      @game_upload.map_contents
    end
    
    it "should correctly capture the columns" do
      @game_upload.contents[0].each_with_index do |col, i|
        @game_upload.columns[i].should == col.to_sym
      end
    end

    it "should create a team_map for each team name" do
      @game_upload.team_maps.length.should == 6
    end

    it "should create a venue_map for each venue name" do
      @game_upload.venue_maps.length.should == 3
    end

  end

  describe "when checking readiness" do
    
  end

  def file_data
    data = []
    data << %w[date time duration left_team right_team venue]
    data << ["8/1/11", "8:00pm", "75", "A", "B", "OIA"]
    data << ["8/1/11", "9:35:00pm", "75", "C", "D", "OIA"]
    data << ["8/8/11", "8:00:00pm", "75", "", "A", ""]
    data << ["8/8/11", "9:35:00pm", "75", "C", "E", "Polar"]
  end


end

# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  type                      :string(255)
#  tenant_id                 :integer
#  team_id                   :integer
#  player_id                 :integer
#  statsheet_id              :integer
#  jersey_number             :string(255)
#  games_played              :integer          default(0)
#  goals                     :integer          default(0)
#  assists                   :integer          default(0)
#  points                    :integer          default(0)
#  penalties                 :integer          default(0)
#  penalty_minutes           :integer          default(0)
#  minor_penalties           :integer          default(0)
#  major_penalties           :integer          default(0)
#  misconduct_penalties      :integer          default(0)
#  game_misconduct_penalties :integer          default(0)
#  hat_tricks                :integer          default(0)
#  playmakers                :integer          default(0)
#  gordie_howes              :integer          default(0)
#  ejections                 :integer          default(0)
#  mongo_id                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string(255)
#  last_name                 :string(255)
#

require 'rails_helper'

RSpec.describe Hockey::Skater, :type => :model do
  
  context "when instantiating" do
    
    before { @skater = Hockey::Skater.new }

    Hockey::Skater.STATS.each do |stat|
      it "has a default value of 0 for #{stat}" do
        expect(@skater.send(stat)).to equal(0)
      end
    end

  end
  
  context "when resetting" do
  
    before do
      @skater = Hockey::Skater.new
      Hockey::Skater.STATS.each do |stat|
        @skater.send("#{stat}=", 1)
      end
    end
    
    Hockey::Skater.STATS.each do |stat|
       it "sets #{stat} to 0" do
         @skater.reset
         expect(@skater.send(stat)).to equal(0)
       end
    end
    
    it "saves when calling with bang!" do
      allow(@skater).to receive(:save)
      @skater.reset!
      expect(@skater).to have_received(:save)
    end
    
  end
  
end

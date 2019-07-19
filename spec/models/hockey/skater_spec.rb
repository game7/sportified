# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  type                      :string
#  tenant_id                 :integer
#  team_id                   :integer
#  player_id                 :integer
#  statsheet_id              :integer
#  jersey_number             :string
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
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string
#  last_name                 :string
#
# Indexes
#
#  index_hockey_skaters_on_player_id     (player_id)
#  index_hockey_skaters_on_statsheet_id  (statsheet_id)
#  index_hockey_skaters_on_team_id       (team_id)
#  index_hockey_skaters_on_tenant_id     (tenant_id)
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

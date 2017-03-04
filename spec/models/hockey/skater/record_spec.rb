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
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string
#  last_name                 :string
#
# Indexes
#
#  index_hockey_skaters_on_mongo_id      (mongo_id)
#  index_hockey_skaters_on_player_id     (player_id)
#  index_hockey_skaters_on_statsheet_id  (statsheet_id)
#  index_hockey_skaters_on_team_id       (team_id)
#  index_hockey_skaters_on_tenant_id     (tenant_id)
#

require 'rails_helper'

RSpec.describe Hockey::Skater::Record, :type => :model do

  def set_stats(obj, val)
    Hockey::Skater.STATS.each do |stat|
      obj.send("#{stat}=", val)
    end    
  end
  
  context "when adding results" do
  
    before do
      @record = Hockey::Skater::Record.new
      @result = Hockey::Skater::Result.new
      set_stats @result, 1
      set_stats @record, 5
    end
    
    Hockey::Skater.STATS.each do |stat|
       it "increments #{stat} according to result" do
         @record.add_result @result
         expect(@record.send(stat)).to equal(6)
       end
    end
    
    Hockey::Skater.STATS.each do |stat|
      it "decrements #{stat} according to result" do
       @record.remove_result(@result)
       expect(@record.send(stat)).to equal(4)
      end
    end
    
    context "and when decrementing" do
    
      before do
        set_stats @result, 3
        set_stats @record, 1
      end
      
      Hockey::Skater.STATS.each do |stat|
        it "decrements #{stat} only to 0" do
         @record.remove_result(@result)
         expect(@record.send(stat)).to equal(0)
        end
      end
    
    end
    
    it "saves when calling add_result with bang!" do
      allow(@record).to receive(:save)
      @record.add_result! @result
      expect(@record).to have_received(:save)
    end
    
    it "saves when calling remove_result with bang!" do
      allow(@record).to receive(:save)
      @record.remove_result! @result
      expect(@record).to have_received(:save)
    end    
    
  end
  
end

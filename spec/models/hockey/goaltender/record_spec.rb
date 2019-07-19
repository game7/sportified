# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  type                     :string
#  tenant_id                :integer
#  team_id                  :integer
#  player_id                :integer
#  statsheet_id             :integer
#  games_played             :integer          default(0)
#  minutes_played           :integer          default(0)
#  shots_against            :integer          default(0)
#  goals_against            :integer          default(0)
#  saves                    :integer          default(0)
#  save_percentage          :float            default(0.0)
#  goals_against_average    :float            default(0.0)
#  shutouts                 :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  regulation_wins          :integer          default(0)
#  regulation_losses        :integer          default(0)
#  overtime_wins            :integer          default(0)
#  overtime_losses          :integer          default(0)
#  shootout_wins            :integer          default(0)
#  shootout_losses          :integer          default(0)
#  total_wins               :integer          default(0)
#  total_losses             :integer          default(0)
#  created_at               :datetime
#  updated_at               :datetime
#  jersey_number            :string
#  first_name               :string
#  last_name                :string
#
# Indexes
#
#  index_hockey_goaltenders_on_player_id     (player_id)
#  index_hockey_goaltenders_on_statsheet_id  (statsheet_id)
#  index_hockey_goaltenders_on_team_id       (team_id)
#  index_hockey_goaltenders_on_tenant_id     (tenant_id)
#

require 'rails_helper'

RSpec.describe Hockey::Goaltender::Record, :type => :model do

  def set_stats(obj, val)
    Hockey::Goaltender.STATS.each do |stat|
      obj.send("#{stat}=", val)
    end    
  end
  
  context "when adding results" do
  
    before do
      @record = Hockey::Goaltender::Record.new
      @result = Hockey::Goaltender::Result.new
      set_stats @result, 1
      set_stats @record, 5
    end
    
    Hockey::Goaltender.STATS.each do |stat|
       it "increments #{stat} according to result" do
         @record.add_result @result
         expect(@record.send(stat)).to eq(6)
       end
    end
    
    Hockey::Goaltender.STATS.each do |stat|
      it "decrements #{stat} according to result" do
       @record.remove_result(@result)
       expect(@record.send(stat)).to eq(4)
      end
    end
    
    context "and when decrementing" do
    
      before do
        set_stats @result, 3
        set_stats @record, 1
      end
      
      Hockey::Goaltender.STATS.each do |stat|
        it "decrements #{stat} only to 0" do
         @record.remove_result(@result)
         expect(@record.send(stat)).to eq(0)
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

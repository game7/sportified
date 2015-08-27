require 'rails_helper'

RSpec.describe Hockey::Skater::Result, :type => :model do
  
  context "when calculating statistics" do
    
    [ [1,3], [1,4], [2,6], [0,1], [0,0]].each do |scenario|
      it "should have #{scenario[0]} hat trick(s) for #{scenario[1]} goal(s)" do
        result = Hockey::Skater::Result.new
        result.goals = scenario[1]
        expect(result.hat_tricks).to equal(scenario[0])
      end
    end
    
    [ [1,3], [1,4], [2,6], [0,1], [0,0]].each do |scenario|
      it "should have #{scenario[0]} playermaker(s) for #{scenario[1]} assist(s)" do
        result = Hockey::Skater::Result.new
        result.assists = scenario[1]
        expect(result.playmakers).to equal(scenario[0])
      end
    end
    
    [
      { goals: 0, assists: 0, points: 0 },
      { goals: 2, assists: 0, points: 2 },
      { goals: 0, assists: 3, points: 3 },
      { goals: 1, assists: 2, points: 3 }
    ].each do |scenario|
      it "should have #{scenario[:points]} points when there are #{scenario[:goals]} G and #{scenario[:assists]} A" do
        result = Hockey::Skater::Result.new
        result.goals = scenario[:goals]
        result.assists = scenario[:assists]
        expect(result.points).to equal(scenario[:points])
      end
    end    
    
    [
      { goals: 1, assists: 1, penalties: 1, gordie_howes: 1 },
      { goals: 0, assists: 1, penalties: 1, gordie_howes: 0 },
      { goals: 1, assists: 0, penalties: 1, gordie_howes: 0 },
      { goals: 1, assists: 1, penalties: 0, gordie_howes: 0 }
    ].each do |scenario|
      it "should have #{scenario[:gordie_howes]} gordie_howes when there are #{scenario[:goals]} G and #{scenario[:assists]} A and #{scenario[:penalties]} PEN" do
        result = Hockey::Skater::Result.new
        result.goals = scenario[:goals]
        result.assists = scenario[:assists]
        result.penalties = scenario[:penalties]
        expect(result.gordie_howes).to equal(scenario[:gordie_howes])
      end
    end
    
  end
  
end
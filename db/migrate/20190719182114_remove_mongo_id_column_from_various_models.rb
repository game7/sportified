class RemoveMongoIdColumnFromVariousModels < ActiveRecord::Migration[5.2]
  def up
    remove_column :blocks, :mongo_id
    remove_column :events, :mongo_id
    remove_column :hockey_goals, :mongo_id
    remove_column :hockey_goaltenders, :mongo_id
    remove_column :hockey_penalties, :mongo_id
    remove_column :hockey_skaters, :mongo_id
    remove_column :hockey_statsheets, :mongo_id
    remove_column :league_divisions, :mongo_id
    remove_column :league_seasons, :mongo_id
    remove_column :league_teams, :mongo_id
    remove_column :locations, :mongo_id
    remove_column :pages, :mongo_id
    remove_column :players, :mongo_id
    remove_column :posts, :mongo_id
    remove_column :sections, :mongo_id
    remove_column :tenants, :mongo_id
    remove_column :user_roles, :mongo_id
    remove_column :users, :mongo_id 
  end
end

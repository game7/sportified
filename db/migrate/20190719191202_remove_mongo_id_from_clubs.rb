class RemoveMongoIdFromClubs < ActiveRecord::Migration[5.2]
  def change
    remove_column :clubs, :mongo_id
  end
end

class AddSubstituteToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :substitute, :boolean
  end
end

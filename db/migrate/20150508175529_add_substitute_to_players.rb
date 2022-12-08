class AddSubstituteToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :substitute, :boolean
  end
end

class AddIndexToPlayerEmail < ActiveRecord::Migration[4.2]
  def change
    add_index :players, :email
  end
end

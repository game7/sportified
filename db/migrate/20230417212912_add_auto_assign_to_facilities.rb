class AddAutoAssignToFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities, :auto_assign, :string
  end
end

class RemoveParentAndPreferenceFromFacilities < ActiveRecord::Migration[5.2]
  def change
    remove_reference :facilities, :parent, index: true
    remove_column :facilities, :preference, type: :string
  end
end

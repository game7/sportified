class RemoveRegistrationsCountFromVariants < ActiveRecord::Migration[5.2]
  def change
    remove_column :variants, :registrations_count, :boolean    
  end
end

class AddRegsitrationsCountToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :registrations_count, :integer
  end
end

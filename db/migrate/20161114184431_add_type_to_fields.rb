class AddTypeToFields < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_fields, :type, :string
  end
end

class AddTypeToFields < ActiveRecord::Migration
  def change
    add_column :rms_fields, :type, :string
  end
end

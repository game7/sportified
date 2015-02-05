class BlocksAddFile < ActiveRecord::Migration
  def change
    add_column :blocks, :file, :string
  end
end

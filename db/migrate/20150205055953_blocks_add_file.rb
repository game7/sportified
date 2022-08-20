class BlocksAddFile < ActiveRecord::Migration[4.2]
  def change
    add_column :blocks, :file, :string
  end
end

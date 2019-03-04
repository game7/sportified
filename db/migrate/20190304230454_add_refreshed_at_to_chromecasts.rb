class AddRefreshedAtToChromecasts < ActiveRecord::Migration[5.2]
  def change
    add_column :chromecasts, :refreshed_at, :datetime
  end
end

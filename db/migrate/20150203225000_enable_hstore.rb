class EnableHstore < ActiveRecord::Migration[4.2]
  def self.up
    enable_extension "hstore"
  end
  def self.down
    disable_extension "hstore"
  end
end

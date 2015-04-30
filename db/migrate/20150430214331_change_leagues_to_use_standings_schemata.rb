class ChangeLeaguesToUseStandingsSchemata < ActiveRecord::Migration
  def change
    add_column :leagues, :standings_schema_id, :string
  end
end

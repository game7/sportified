class ChangeLeaguesToUseStandingsSchemata < ActiveRecord::Migration[4.2]
  def change
    add_column :leagues, :standings_schema_id, :string
  end
end

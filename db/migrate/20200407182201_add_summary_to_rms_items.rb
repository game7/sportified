class AddSummaryToRmsItems < ActiveRecord::Migration[5.2]
  def change
    add_column :rms_items, :summary, :text
  end
end

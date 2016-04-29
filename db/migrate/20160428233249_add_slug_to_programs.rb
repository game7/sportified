class AddSlugToPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.string :slug, index: true
    end
    reversible do |change|
      change.up do
        Program.unscoped.all.each{|p| p.save}
      end
    end
  end
end

class AddSlugToPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.string :slug, index: true
    end
    reversible do |change|
      change.up do
        Program.unscoped.all.each do |program|
          program.save
          puts "sluggified #{program.name} to #{program.slug}"
        end
      end
    end
  end
end

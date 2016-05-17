class AddSlugToPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.string :slug, index: true
    end
    reversible do |change|
      change.up do
        Program.reset_column_information
        Program.unscoped.all.each do |program|
          program.set_slug
          if program.save!
            puts "sluggified #{program.name} to #{program.slug}"
          else
            puts program.errors.to_json
          end
        end
      end
    end
  end
end

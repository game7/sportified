class UpdateFormElementTypeModelName < ActiveRecord::Migration[5.2]
  def up
    FormElement.connection.execute("UPDATE form_elements SET type = REPLACE(type, 'Rms::', '');")
  end

  def down
    FormElement.connection.execute("UPDATE form_elements SET type = 'Rms::' || type;")
  end
end

class AddPacketToRmsItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :rms_registrations, :form_packet
    add_foreign_key :rms_registrations, :rms_form_packets, column: :form_packet_id, primary_key: :id
  end
end

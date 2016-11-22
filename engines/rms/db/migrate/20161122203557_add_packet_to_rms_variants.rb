class AddPacketToRmsVariants < ActiveRecord::Migration
  def change
    add_reference :rms_variants, :form_packet
    add_foreign_key :rms_variants, :rms_form_packets, column: :form_packet_id, primary_key: :id
  end
end

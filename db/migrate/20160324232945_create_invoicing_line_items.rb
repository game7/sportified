class CreateInvoicingLineItems < ActiveRecord::Migration[4.2]
  def change
    create_table :invoicing_line_items do |t|
      t.references :ledger_item

      t.string   :type
      t.decimal  :net_amount, precision: 20, scale: 4
      t.decimal  :tax_amount, precision: 20, scale: 4

      # These are optional fields, can be specified via options.
      t.string   :description
      t.string   :uuid, limit: 40
      t.datetime :tax_point
      t.decimal  :quantity, precision: 20, scale: 4
      t.integer  :creator_id

      t.timestamps
    end
  end
end

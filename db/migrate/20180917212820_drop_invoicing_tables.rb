class DropInvoicingTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :invoicing_tax_rates
    drop_table :invoicing_ledger_items
    drop_table :invoicing_line_items
  end
end

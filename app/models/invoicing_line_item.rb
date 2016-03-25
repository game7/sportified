# == Schema Information
#
# Table name: invoicing_line_items
#
#  id             :integer          not null, primary key
#  ledger_item_id :integer
#  type           :string
#  net_amount     :decimal(20, 4)
#  tax_amount     :decimal(20, 4)
#  description    :string
#  uuid           :string(40)
#  tax_point      :datetime
#  quantity       :decimal(20, 4)
#  creator_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class InvoicingLineItem < ActiveRecord::Base
  acts_as_line_item

  belongs_to :ledger_item, class_name: 'InvoicingLedgerItem'
end

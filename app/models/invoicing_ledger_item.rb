# == Schema Information
#
# Table name: invoicing_ledger_items
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  type         :string
#  issue_date   :datetime
#  currency     :string(3)        not null
#  total_amount :decimal(20, 4)
#  tax_amount   :decimal(20, 4)
#  status       :string(20)
#  identifier   :string(50)
#  description  :string
#  period_start :datetime
#  period_end   :datetime
#  uuid         :string(40)
#  due_date     :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class InvoicingLedgerItem < ActiveRecord::Base
  acts_as_ledger_item

  has_many :line_items, class_name: 'InvoicingLineItem', foreign_key: :ledger_item_id
end

# == Schema Information
#
# Table name: invoicing_tax_rates
#
#  id             :integer          not null, primary key
#  description    :string
#  rate           :decimal(20, 4)
#  valid_from     :datetime         not null
#  valid_until    :datetime
#  replaced_by_id :integer
#  is_default     :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

class InvoicingTaxRate < ActiveRecord::Base
  acts_as_tax_rate
end

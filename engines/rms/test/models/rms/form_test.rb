# == Schema Information
#
# Table name: rms_forms
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  tenant_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

module Rms
  class FormTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end

# == Schema Information
#
# Table name: registrar_sessions
#
#  id                      :integer          not null, primary key
#  registrable_id          :integer
#  registrable_type        :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe Registrar::SessionsController, :type => :controller do

end

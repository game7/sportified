# == Schema Information
#
# Table name: programs
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  type        :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class ProgramsController < ApplicationController

  def index
    @programs = Program.order(:name)
  end

  def show
    @program = Program.find_by!(slug: params[:slug])
  end

end

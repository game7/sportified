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
# Indexes
#
#  index_programs_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_3e00a094b5  (tenant_id => tenants.id)
#

class Program < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :tenant

  has_many :events

  validates :name, presence: true

  before_save :set_slug
  def set_slug
    self.slug = self.name.parameterize
  end

  def module_name
    self.class.name.deconstantize.underscore.presence
  end

  scope :with_slug, ->(slug) { where(:slug => slug) }

end

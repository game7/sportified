# == Schema Information
#
# Table name: programs
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string
#  slug        :string
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :integer
#
# Indexes
#
#  index_programs_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
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

# == Schema Information
#
# Table name: forms
#
#  id              :integer          not null, primary key
#  completed       :boolean          default(FALSE), not null
#  data            :hstore
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  registration_id :integer
#  template_id     :integer
#  tenant_id       :integer
#
# Indexes
#
#  index_forms_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#  fk_rails_...  (template_id => form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class Form < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :registration
  belongs_to :template, class_name: 'FormTemplate'
  has_many :elements, -> {order(:position)},
                    through: :template,
                    class_name: 'FormElement'

  store_accessor :data

  validates :registration, presence: true
  validates :template, presence: true

  validate :validate_elements
  def validate_elements
    template.elements.each do |element|
      element.validate(self)
    end
  end

  scope :incomplete, -> { where.not(completed: true) }

  # after_initialize :add_element_accessors
  def add_element_accessors
    self.template.elements.each do |element|
      element.accessors.each do |accessor|
        singleton_class.class_eval { store_accessor :data, accessor }
      end
    end
    self
  end  
end

# == Schema Information
#
# Table name: form_elements
#
#  id          :integer          not null, primary key
#  hint        :string
#  name        :string(40)
#  position    :integer
#  properties  :hstore
#  required    :boolean
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :integer
#  tenant_id   :integer
#
# Indexes
#
#  index_form_elements_on_template_id_and_name  (template_id,name) UNIQUE
#  index_form_elements_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class FormElement < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :template, class_name: 'FormTemplate'
  validates :template, presence: true

  validates :name, presence: true
  validates :type, presence: true
  validates :position, presence: true,
                       numericality: { only_integer: true }

  def partial
    self.class.name.split('::').last.downcase
  end

  def validate(record)
    record.errors.add(name, "Can't be blank") if required? and record.try(:data).try(:[], name).blank?
  end

  def permitted_params
    [name]
  end

  def accessors
    [name]
  end

  before_save :format_name

  def format_name
    self.name = name.parameterize(separator: '_')
  end

  def as_json(options = {})
    options = options.try(:clone) || {}
    options[:methods] = Array(options[:methods]).map(&:to_sym)
    options[:methods] |= [:type]

    super(options)
  end
end

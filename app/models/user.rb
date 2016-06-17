# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  mongo_id               :string
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable

  has_and_belongs_to_many :tenants
  has_many :roles, foreign_key: :user_id, class_name: 'UserRole'

  before_save :capture_tenant_at_sign_in

  has_many :roles, :class_name => "UserRole"
  has_many :authentications

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email, :case_sensitive => false

  scope :with_email, ->(email) { where(:email => email) }

  def role?(role)
    return !!(self.roles.find_by_name(role.to_s).first)
  end

  class << self
    def for_tenant(t)
      id = t.class.to_s == "Tenant" ? t.id : t
      joins(:tenants).where(tenants: { id: id })
    end
    def find_by_auth_provider_and_uid(provider, uid)
      where("authentications.provider" => provider, "authentications.uid" => uid).first
    end
  end

  def apply_omniauth(omniauth)
    self.name = omniauth['user_info']['name'] if name.blank?
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end


  protected

  def set_id
    self._id = self.name if self._id.blank?
  end

  def capture_tenant_at_sign_in
     capture_tenant if self.sign_in_count_changed?
  end

  def capture_tenant
    unless self.tenants.all.include?(Tenant.current)
      self.tenants << Tenant.current
    end
  end

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

end

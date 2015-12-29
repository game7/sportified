class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
        
  has_and_belongs_to_many :tenants        
  has_many :roles, foreign_key: :user_id, class_name: 'UserRole'
  
  before_save :capture_tenant_at_sign_in

  has_many :roles, :class_name => "UserRole"
  has_many :authentications

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :case_sensitive => false

  scope :with_email, ->(email) { where(:email => email) }

  def role?(role)
    return !!(self.roles.find_by_name(role.to_s).first)
  end

  class << self
    def for_tenant(t)
      id = t.class.to_s == "Tenant" ? t.id : t
      where(:tenant_ids => id)
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
  
  def apply_mongo_tenant_ids!(user)
    
  end
  
  def apply_mongo_encrypted_password!(mongo_password)
    self.password = 'mongo_password'
    self.encrypted_password = mongo_password
  end

  def apply_mongo_roles!(mongo_roles)
  end

  protected

  def set_id
    self._id = self.name if self._id.blank?
  end

  def capture_tenant_at_sign_in
     capture_tenant if self.sign_in_count_changed?
  end

  def capture_tenant
    if Tenant.current
      self.tenant_ids ||= []
      self.tenant_ids << Tenant.current.id unless tenant_ids.include?(Tenant.current.id)
    end
  end

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end
  
end
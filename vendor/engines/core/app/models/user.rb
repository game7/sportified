class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  key :name
  index :email, :unique => true

  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation

  protected
    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end

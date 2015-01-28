module Sql
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, 
            :recoverable, :rememberable, :trackable, :validatable,
            :omniauthable
          
    has_and_belongs_to_many :tenants        
    has_many :roles, foreign_key: :user_id, class_name: 'UserRole'
    
    def apply_mongo_tenant_ids!(value)
      
    end
    
  end
end
class Ability
  include CanCan::Ability

  def initialize(user, curr_tenant = nil)
    
    user ||= User.new # guest user
    curr_tenant_id = curr_tenant.class == Tenant ? curr_tenant.id : curr_tenant

    if user.role? :super_admin
      can :manage, :all
    elsif curr_tenant_id
      user.roles.find_by_name(:admin).each do |role|
        can :manage, :all if role.tenant_id == curr_tenant_id
      end
    end
    
  end
end

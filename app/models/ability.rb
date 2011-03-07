class Ability
  include CanCan::Ability

  def initialize(user, curr_site = nil)
    
    user ||= User.new # guest user
    curr_site_id = curr_site.class == Site ? curr_site.id : curr_site

    if user.role? :super_admin
      can :manage, :all
    elsif curr_site_id
      user.roles.find_by_name(:site_admin).each do |role|
        can :manage, :all if role.site_id == curr_site_id
      end
    end
    
  end
end

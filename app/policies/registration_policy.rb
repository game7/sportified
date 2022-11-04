class RegistrationPolicy < ApplicationPolicy

  def destroy?
    return false if record.order.present? && !record.order.pending?
    true
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end

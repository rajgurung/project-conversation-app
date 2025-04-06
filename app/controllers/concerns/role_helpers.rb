module RoleHelpers
  extend ActiveSupport::Concern

  included do
    helper_method :admin?, :staff?, :client?
  end

  def admin?
    current_user&.role_for(current_tenant) == Membership::ADMIN
  end

  def staff?
    current_user&.role_for(current_tenant) == Membership::STAFF
  end

  def client?
    current_user&.role_for(current_tenant) == Membership::CLIENT
  end
end

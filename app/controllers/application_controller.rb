class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Helper method to ensure that current tenant is set.
  helper_method :current_tenant

  def current_tenant
    @current_tenant ||= Tenant.find(session[:current_tenant_id]) if session[:current_tenant_id]
  end
end

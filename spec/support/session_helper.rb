module SessionHelper
  def set_current_tenant_session(tenant)
    # Emulates session set in controller
    Rails.application.env_config['rack.session'] ||= {}
    Rails.application.env_config['rack.session'][:current_tenant_id] = tenant.id
  end
end

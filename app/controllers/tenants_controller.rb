class TenantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tenants = current_user.tenants
  end

  def switch
    tenant = current_user.tenants.find(params[:id])

    if tenant
      session[:current_tenant_id] = tenant.id
      redirect_to projects_path, notice: "Switched to #{tenant.name}"
    else
      redirect_to tenants_path, alert: "Tenant not found"
    end
  end
end

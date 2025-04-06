module ApplicationHelper
  def show_back_to_projects_link?
    return false if devise_controller? && action_name.in?(%w[new create])
    return false if controller_name == 'tenants' && action_name == 'index'
    true
  end
end

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [ :destroy ]
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :change_status ]
  before_action :authorize_editor!, only: [ :edit, :update, :change_status ]

  def index
    @projects = current_tenant.projects.preload(:comments)
  end

  def show
    @project = current_tenant.projects.find(params[:id])
  end

  def new
    @project = current_tenant.projects.build
  end

  def create
    @project = current_tenant.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project was successfully destroyed."
  end

  def change_status
    @project = current_tenant.projects.find(params[:id])

    from_status = @project.status
    to_status = params[:to_status]
    reason = params[:reason]

    if to_status == "Archived" && current_user.role_for(current_tenant) != "admin"
      redirect_to @project, alert: "Only admins can archive a project."
      return
    end

    if Project::STATUSES.include?(to_status) && from_status != to_status
      @project.update!(status: to_status)

      @project.comments.create!(
        comment_type: "status_change",
        user: current_user,
        from_status: from_status,
        to_status: to_status,
        reason: reason
      )

      # Send Mailer after status has been changed!
      # ProjectNotifierMailer.comment_added(@project, @comment, user).deliver_later

      redirect_to @project, notice: "Status updated from #{from_status} to #{to_status}."
    else
      redirect_to @project, alert: "Invalid or unchanged status."
    end
  end

  private

  def set_project
    @project = current_tenant.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :status)
  end

  def authorize_admin!
    unless current_user.role_for(current_tenant) == Membership::ADMIN
      redirect_to projects_path, alert: "You are not authorised to perform this action."
    end
  end

  def authorize_editor!
    unless current_user.role_for(current_tenant).in?(%w[admin staff])
      redirect_to project_path(@project), alert: "You are not authorised to change project status"
    end
  end
end

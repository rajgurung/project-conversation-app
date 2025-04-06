class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @comment = @project.comments.new(comment_params)
    @comment.user = current_user
    @comment.comment_type = "comment" # only allow manual comment

    if @comment.save
      # Send Mailer after status has been changed!
      # ProjectNotifierMailer.comment_added(@project, @comment, user).deliver_later

      redirect_to @project, notice: "Comment added."
    else
      redirect_to @project, alert: "Unable to add comment."
    end
  end

  private

  def set_project
    @project = current_tenant.projects.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

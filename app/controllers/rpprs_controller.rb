class RpprsController < ApplicationController
  include ApplicationHelper

  def index
    @project_id = params[:project_id]
    @project = Project.find(@project_id)

    respond_to do |format|
      format.html { redirect_to welcome_dashboard_path }
      format.js
    end
  end

  def update_dates
    @rppr = Rppr.find(params[:id])
    @rppr.due_date = Date.parse(params[:due_date]) if params[:due_date].present?
    @rppr.start_date = Date.parse(params[:start_date]) if params[:start_date].present?
    @rppr.end_date = Date.parse(params[:end_date]) if params[:end_date].present?

    @rppr.save!
    ActionLog.create(user_id: current_user.id, subject_id: @rppr.id, subject_type: @rppr.class.name, data: @rppr.saved_changes)

    flash[:success] = "DMS progress report dates updated successfully."
    redirect_to edit_rppr_user_path(id: current_user.id, rppr_id: @rppr.id) and return
  end

  # new_comment_rppr GET    /rpprs/:id/new_comment(.:format)
  def new_comment
    @rppr = Rppr.find(params[:rppr_id])
    @parent_comment = Comment.find(params[:parent_id])
  end

  # create_comment_rppr POST   /rpprs/:id/create_comment(.:format)
  def create_comment
    @rppr = Rppr.find(params[:rppr_id])
    comment = Comment.build_from(@rppr, current_user.id, params[:body])

    respond_to do |format|
      if comment.save!
        if params[:parent_id].present?
          parent_comment = Comment.find(params[:parent_id])
          comment.move_to_child_of(parent_comment)
        end

        @root_comments = @rppr.reload.root_comments
        CommentMailer.notice_comment(@rppr, comment).deliver_later
        flash[:success] = "successfully left the comment"
      else
        flash[:alert] = "fail to leave the comment. error: #{comment.errors.full_messages}"
      end

      format.js
    end
  end

  # edit_comment_rppr GET    /rpprs/:id/edit_comment(.:format)
  def edit_comment
    @comment = Comment.find(params[:comment_id])
  end

  # update_comment_rppr POST   /rpprs/:id/update_comment(.:format)
  def update_comment
    @comment = Comment.find(params[:comment_id])
    @comment.body = params[:body] if params[:body].present?
    # use subject to indicate removed comment
    @comment.subject = params[:subject] if params[:subject].present?

    respond_to do |format|
      if @comment.save!
        @rppr = Rppr.find(@comment.commentable_id)
        @root_comments = @rppr.root_comments
        flash[:success] = "successfully updated the comment"
      else
        flash[:alert] = "fail to update the comment. error: #{@comment.errors.full_messages}"
      end

      format.js { render :template => "rpprs/create_comment.js.erb" }
    end
  end
end

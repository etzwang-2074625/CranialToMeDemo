class CommentMailer < ApplicationMailer
  def notice_comment(rppr, comment)
    @rppr = rppr
    @comment = comment
    @award_number = @rppr.project.project_number
    @deput_domain = "https://deput.uth.edu/"

    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?


    # Since only SPA and PI can access the progress report, it does not need to query all of the users in the comments
    # TODO: if we need to query all users, use `rppr.comment_threads` and filter all users
    user = User.find @comment.user_id
    @sender_name = "#{user.user_firstname} #{user.user_lastname}"
    if user.has_role?('SPA')
      @receiver_name = @rppr.project.contact_pi
      @to = @rppr.project.pi_email
    else
      @receiver_name = 'Data Science Librarian'
      @to = ENV['SPA_EMAIL_LIST'].present? ? ENV['SPA_EMAIL_LIST'].split(',') : User.joins(:roles).where(roles: { name: 'SPA' }).map(&:email)
    end

    start_date = @rppr.start_date.nil? ? "" : "#{@rppr.start_date.strftime("%m/%d/%Y")}"
    end_date = @rppr.end_date.nil? ? "" : "#{@rppr.end_date.strftime("%m/%d/%Y")}"
    @report_period = "#{start_date} - #{end_date}"
    @parent_comment = @comment.parent


    mail(to: @to, bcc: @bcc, subject: "UTHealth DEPUT - Research Progress Report(#{@award_number}) has a new comment")
  end

end

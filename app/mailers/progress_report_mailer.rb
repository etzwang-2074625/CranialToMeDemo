class ProgressReportMailer < ApplicationMailer
  def remind_due(rppr = nil, due_days)
    @rppr = rppr
    @award_number = @rppr.project.project_number
    @project_title = @rppr.project.project_title
    @deput_domain = "https://deput.uth.edu/"
    @due_days = due_days
    @to = rppr.project.pi_email
    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?

    mail(to: @to, bcc: @bcc, subject: "UTHealth DEPUT - Research Progress Report(#{@award_number}) due reminder")
  end

  def request_review(rppr = nil)
    @rppr = rppr
    @award_number = @rppr.project.project_number
    @project_title = @rppr.project.project_title
    @pi_name = rppr.project.contact_pi
    @deput_domain = "https://deput.uth.edu/"
    # honor env for testing purpose
    @spa_user_emails = ENV['SPA_EMAIL_LIST'].present? ? ENV['SPA_EMAIL_LIST'].split(',') : User.joins(:roles).where(roles: { name: 'SPA' }).map(&:email)
    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?

    mail(to: @spa_user_emails, bcc: @bcc, subject: "UTHealth DEPUT - Progress Report(#{@award_number}) ready for review")
  end

  def remind_edit(rppr = nil)
    @rppr = rppr
    @award_number = @rppr.project.project_number
    @project_title = @rppr.project.project_title
    @deput_domain = "https://deput.uth.edu/"
    @to = rppr.project.pi_email
    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?

    mail(to: @to, bcc: @bcc, subject: "UTHealth DEPUT - Research Progress Report(#{@award_number}) further information required")
  end

  def notice_approval(rppr = nil)
    @rppr = rppr
    @award_number = @rppr.project.project_number
    @pi_name = @rppr.project.contact_pi
    @report_period = report_period
    @to = @rppr.project.pi_email
    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?

    mail(to: @to, bcc: @bcc, subject: "UTHealth DEPUT - Research Progress Report(#{@award_number}) is approved")
  end

  def remind_overdue(rppr = nil)
    @rppr = rppr
    @award_number = @rppr.project.project_number
    @project_title = @rppr.project.project_title
    @report_period = report_period

    @to = rppr.project.pi_email
    @bcc = ENV['NOTIFICATION_EMAIL_BCC_LIST'].split(',') if ENV['NOTIFICATION_EMAIL_BCC_LIST'].present?

    mail(to: @to, bcc: @bcc, subject: "UTHealth DEPUT - Research Progress Report(#{@award_number}) overdue")
  end

  private

  def report_period
    start_date = @rppr.start_date.nil? ? "" : "#{@rppr.start_date.strftime("%m/%d/%Y")}"
    end_date = @rppr.end_date.nil? ? "" : "#{@rppr.end_date.strftime("%m/%d/%Y")}"

    "#{start_date} - #{end_date}"
  end
end

class DueDateReminderJob < ApplicationJob
  queue_as :default

  def perform(due_days)
    logger = Logger.new("log/due_date_reminder-#{due_days}-days.log")
    # query the rppr with (due date - today) equal to <days_before_due_date> days
    rpprs_require_remind = Rppr.where(status: 1).or(Rppr.where(status: 3)).where("DATE(due_date) = ?", due_days.to_i.days.from_now.to_date)
    logger.info "*** delivering reminder for the number of #{rpprs_require_remind.count} rpprs in the system ***"
    rpprs_require_remind.each do |rppr|
      logger.info "delivering reminder for rppr id = #{rppr.id}, rppr.due_date = #{rppr.due_date}"
      ProgressReportMailer.remind_due(rppr, due_days.to_i).deliver_now
    end
  end
end

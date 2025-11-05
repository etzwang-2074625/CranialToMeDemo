class OverdueReminderJob < ApplicationJob
  queue_as :default

  def perform
    logger = Logger.new("log/overdue_reminder.log")
    overdue_rpprs_require_remind = Rppr.where(status: 1).or(Rppr.where(status: 3)).where("DATE(due_date) = ?", Date.yesterday)
    logger.info "*** delivering reminder for the number of #{overdue_rpprs_require_remind.count} rpprs in the system ***"
    overdue_rpprs_require_remind.each do |rppr|
      logger.info "delivering reminder for rppr id = #{rppr.id}, rppr.due_date = #{rppr.due_date}"
      ProgressReportMailer.remind_overdue(rppr).deliver_now
    end
  end
end

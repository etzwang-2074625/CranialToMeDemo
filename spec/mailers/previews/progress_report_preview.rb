# Preview all emails at http://localhost:3000/rails/mailers/progress_report
class ProgressReportPreview < ActionMailer::Preview
  def remind_due
    ProgressReportMailer.remind_due(Rppr.first)
  end

  def request_review
    ProgressReportMailer.request_review(Rppr.first)
  end

  def remind_edit(rppr = nil)
    ProgressReportMailer.remind_edit(Rppr.first)
  end

  def notice_approval(rppr = nil)
    ProgressReportMailer.notice_approval(Rppr.first)
  end
end

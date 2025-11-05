desc "Remind pi to submit the progress report before due date"
# rake 'due_date_reminder[60]'
task :due_date_reminder, [:days_before_due_date] => [:environment] do |task, args|
  DueDateReminderJob.perform_now(args[:days_before_due_date].to_i)
  # TODO: send mail to admin as health check
end

task :overdue_reminder => [:environment] do |task, args|
  OverdueReminderJob.perform_now()
  # TODO: send mail to admin as health check
end

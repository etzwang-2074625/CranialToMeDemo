require 'rails_helper'

RSpec.describe OverdueReminderJob, type: :job do
  let(:due_date) { Time.use_zone("Central Time (US & Canada)") { Time.zone.parse("2022-08-05 10:00:00") } }
  let(:days_after_due_date) { 1 }
  let(:progress_report_1_status) { 1 }
  let(:progress_report_2_status) { 3 }

  before do
    create(:rppr, status: progress_report_1_status, due_date: due_date)
    create(:rppr, status: progress_report_2_status, due_date: due_date)
  end

  context 'due date is today' do
    it 'does not send the reminder' do
      travel_to (due_date)

      expect(ProgressReportMailer).to receive(:remind_due).and_call_original.never

      OverdueReminderJob.perform_now()
    end
  end

  context 'due date is yesterday' do
    context 'rppr status is 1 or 3' do
      it 'sends the reminder' do
        puts "due_date = #{due_date}"
        puts "due_date + days_after_due_date.days = #{due_date + days_after_due_date.days}"
        travel_to (due_date + days_after_due_date.days)

        expect(ProgressReportMailer).to receive(:remind_overdue).and_call_original.twice

        OverdueReminderJob.perform_now()
      end
    end

    context 'one of rppr status is not 1 or 3' do
      let(:progress_report_1_status) { 1 }
      let(:progress_report_2_status) { 2 }

      it 'does not send all of the reminder' do
        travel_to (due_date + days_after_due_date.days)

        expect(ProgressReportMailer).to receive(:remind_overdue).and_call_original.once

        OverdueReminderJob.perform_now()
      end
    end
  end

  context 'due date is the day before yesterday' do
    it 'does not send the reminder' do
      travel_to (due_date + days_after_due_date.days + 1.days)

      expect(ProgressReportMailer).to receive(:remind_due).and_call_original.never

      OverdueReminderJob.perform_now()
    end
  end
end

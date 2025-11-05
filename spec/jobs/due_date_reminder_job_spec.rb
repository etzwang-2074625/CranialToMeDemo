require 'rails_helper'

RSpec.describe DueDateReminderJob, type: :job do
  let(:due_date) { Time.use_zone("Central Time (US & Canada)") { Time.zone.parse("2022-08-05 10:00:00") } }
  let(:days_to_remind) { 60 }
  let(:progress_report_1_status) { 1 }
  let(:progress_report_2_status) { 3 }

  before do
    create(:rppr, status: progress_report_1_status, due_date: due_date)
    create(:rppr, status: progress_report_2_status, due_date: due_date)
  end

  context 'due date is within 60 days window' do
    context 'rppr status is 1 or 3' do
      it 'sends the reminder' do
        travel_to (due_date - days_to_remind.days)

        expect(ProgressReportMailer).to receive(:remind_due).and_call_original.twice

        DueDateReminderJob.perform_now(days_to_remind)
      end
    end

    context 'one of rppr status is not 1 or 3' do
      let(:progress_report_1_status) { 1 }
      let(:progress_report_2_status) { 2 }

      it 'does not send all of the reminder' do
        travel_to (due_date - days_to_remind.days)

        expect(ProgressReportMailer).to receive(:remind_due).and_call_original.once

        DueDateReminderJob.perform_now(days_to_remind)
      end
    end
  end

  context 'due date is out of 60 days window' do
    it 'does not send the reminder' do
      travel_to (due_date - days_to_remind.days - 1.days)

      expect(ProgressReportMailer).to receive(:remind_due).and_call_original.never

      DueDateReminderJob.perform_now(days_to_remind)
    end
  end
end

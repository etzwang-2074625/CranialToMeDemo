require 'rails_helper'
# bundle exec rspec spec/models/rppr_spec.rb
RSpec.describe Rppr, type: :model do
  describe "#send_email" do
    context 'status was in progress' do
      before do
        @rppr = create(:rppr, status: 1)
      end

      context 'updated to submitted' do
        it 'sends the request_review reminder' do
          mail = double(:mail)
          allow(mail).to receive(:deliver_later)
          expect(ProgressReportMailer).to receive(:request_review).and_return(mail)
          @rppr.status = 2
          @rppr.save
        end
      end
    end

    context 'status was submitted' do
      before do
        @rppr = create(:rppr, status: 2)
      end

      context 'updated to return for editting' do
        it 'sends the remind_edit reminder' do
          mail = double(:mail)
          allow(mail).to receive(:deliver_later)
          expect(ProgressReportMailer).to receive(:remind_edit).and_return(mail)
          @rppr.status = 3
          @rppr.save
        end
      end

      context 'updated to approved' do
        it 'sends the notice_approval reminder' do
          mail = double(:mail)
          allow(mail).to receive(:deliver_later)
          expect(ProgressReportMailer).to receive(:notice_approval).and_return(mail)
          @rppr.status = 4
          @rppr.save
        end
      end
    end
  end
end

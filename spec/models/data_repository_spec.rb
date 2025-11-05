require 'rails_helper'

RSpec.describe DataRepository, type: :model do
  describe "#uniqueness" do
    before do
      @user_a = create(:user, user_firstname: 'user_a')
      @user_b = create(:user, user_firstname: 'user_b')
      create(:data_repository, user: @user_a, name: 'first')
    end

    context 'belongs to same user' do
      context 'has same name' do
        it 'raises an error' do
          new_data_repository = DataRepository.new(user: @user_a, name: 'first')
          expect { new_data_repository.save! }.to raise_error(ActiveRecord::RecordInvalid) do |error|
            expect(error.message).to include("Name should be unique within the same user")
          end
        end
      end
    end

    context 'belongs to different user' do
      context 'has same name' do
        it 'creates the data repository with success' do
          new_data_repository = DataRepository.new(user: @user_b, name: 'first')
          expect { new_data_repository.save! }.to change { DataRepository.count }.by(1)
        end
      end
    end
  end
end

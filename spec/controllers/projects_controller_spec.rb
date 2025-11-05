require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    user = create(:user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #approve_rppr" do
    let!(:rppr) { create(:rppr, status: 1) }

    it "redirect to welcome_dashboard_path" do
      post :approve_rppr, params: { id: 1, rppr_id: rppr.id }
      expect(rppr.reload.status).to eq(4)
      expect(response).to redirect_to(welcome_dashboard_path)
    end
  end

  describe "POST #return_rppr" do
    let!(:rppr) { create(:rppr, status: 1) }

    it "redirect to welcome_dashboard_path" do
      post :return_rppr, params: { id: 1, rppr_id: rppr.id }
      expect(rppr.reload.status).to eq(3)
      expect(response).to redirect_to(welcome_dashboard_path)
    end
  end
end

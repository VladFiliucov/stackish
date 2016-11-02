require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe "GET #create" do
    login_user

    it "returns http success" do
      post :create, id: question.id, format: :json
      expect(response.status).to eq(201)
    end

    it "creates subscription" do
      expect { post :create, id: question.id, format: :json }.to change(question.subscriptions, :count).by 1
    end
  end

  describe "GET #destroy" do
    context 'guest' do
      let(:subscription) { create(:subscription, user: user, question: question) }

      it "returns unauthorized" do
        delete :destroy, id: question, format: :json
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'author' do
      login_user
      let!(:subscription) { create(:subscription, user: @user, question: question) }

      it "returns http success" do
        delete :destroy, id: question, format: :json
        expect(response).to have_http_status(:success)
      end

      it "deletes subscription" do
        expect { delete :destroy, id: question, format: :json }.to change(question.subscriptions, :count).by(-1)
      end
    end
  end
end

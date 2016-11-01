require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #create" do
    login_user

    it "returns http success" do
      post :create, subscription: attributes_for(:subscription)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    login_user

    context 'author' do
      let(:question) { create(:question) }
      let(:subscription) { create(:subscription, user: @user, question: question) }

      it "returns http success" do
        delete :destroy, id: subscription
        expect(response).to have_http_status(:success)
      end
    end
  end

end

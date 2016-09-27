require 'rails_helper'

RSpec.describe UserAgreementsController, type: :controller do

  describe "GET #terms_and_conditions" do
    it "returns http success" do
      get :terms_and_conditions
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #policies" do
    it "returns http success" do
      get :policies
      expect(response).to have_http_status(:success)
    end
  end

end

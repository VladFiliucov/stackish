require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #facebook' do
    context 'existing user' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
          {
            provider: 'facebook',
            uid: '555555',
            info: {
              email: 'email@gmail.com'
            }
          }
        )
        get :facebook
      end

      it 'assigns @user' do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it { should respond_with(302) }
      it { should redirect_to root_path }
    end
  end

  describe 'GET #twitter' do
    before do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        {
          provider: 'twitter',
          uid: '555555',
          info: {
            email: 'email@gmail.com'
          }
        }
      )
      get :twitter
    end

    it 'assigns @user' do
      expect(assigns(:user)).to be_an_instance_of(User)
    end

    it { should respond_with(302) }
    it { should redirect_to root_path }
  end
end

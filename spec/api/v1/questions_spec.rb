require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }

      it 'returns status code 200' do
        get '/api/v1/questions', format: :json, access_token: access_token.token
        expect(response).to be_success
      end
    end
  end
end

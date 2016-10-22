require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do

    it_behaves_like "API Authenticatable"

    context 'authenticated' do
      let!(:me) { create(:user, admin: true) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', format: :json, access_token: access_token.token
      end

      it 'returns success status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains {attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /all_excep_current' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles/all_except_current', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/all_except_current', format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:user_list){ create_list(:user, 2) }

      before do
        get '/api/v1/profiles/all_except_current', format: :json, access_token: access_token.token
      end

      it 'returns success status' do
        expect(response).to be_success
      end

      it 'does not include current resource owner' do
        expect(response.body).not_to include_json(me.to_json)
      end

      it 'contains all users from list' do
        expect(response.body).to be_json_eql(user_list.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "first user in list contains {attr}" do
          expect(response.body).to be_json_eql(user_list.first.send(attr.to_sym).to_json).at_path('0/' + attr)
        end

        it "second user in list contains {attr}" do
          expect(response.body).to be_json_eql(user_list.second.send(attr.to_sym).to_json).at_path('1/' + attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "first user in list does not contain #{attr}" do
          expect(response.body).to_not have_json_path('0/' + attr)
        end
      end
    end
  end
end

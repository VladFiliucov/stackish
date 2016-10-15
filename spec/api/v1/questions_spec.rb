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
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get '/api/v1/questions', format: :json, access_token: access_token.token
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions/")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'with answers' do
        it 'included' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "questions answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions/1', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions/1', format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question, user: user) }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end
end

require 'rails_helper'

describe 'Answers API' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let(:access_token){ create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do

      before do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end

      xit 'returns 401 status if access token is invalid' do
        get '/api/v1/questions/1', format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question)}

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      xit 'returns status code 200' do
        expect(response).to be_success
      end

      xit 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        xit "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'with answers' do
        xit 'included' do
          expect(response.body).to have_json_size(2).at_path("question/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          xit "questions answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'with comments' do
        xit 'included' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          xit "questions comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'with attachments' do
        xit 'included' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(url).each do |attr|
          xit "questions attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
  end
end

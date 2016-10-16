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
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '12345'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer)}

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end

      it 'returns the answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'with comments' do
        it 'included' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "answers comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'with attachments' do
        it 'included' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(url).each do |attr|
          it "answers attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '12345', answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:create_valid_answer) {post "/api/v1/questions/#{question.id}/answers",
                                 answer: attributes_for(:answer),
                                 format: :json, access_token: access_token.token }

      context 'with valid attributes' do
        it 'expect success status' do
          create_valid_answer
          expect(response).to be_success
        end

        it 'creates new answer' do
          expect { create_valid_answer }
            .to change(Answer, :count).by(1)
        end

        it 'assigns answer to user' do
          create_valid_answer
          expect(assigns(:answer).user).to eq User.find(access_token.resource_owner_id)
        end

        it 'assigns answer to question' do
          expect {create_valid_answer}.to change(question.answers, :count)
        end
      end

      context 'with invaid attributes' do
        let(:create_invalid_answer) {post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:blank_answer) }

        it 'returns unprocessable entity' do
          create_invalid_answer
          expect(response.status).to eq(422)
        end

        it "doesn't save the answer" do
          expect { create_invalid_answer }
            .to_not change(Answer, :count)
        end
      end
    end
  end
end

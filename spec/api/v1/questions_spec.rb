require 'rails_helper'
# require 'support/shared/api_authorization'

describe 'Questions API' do
  describe 'GET /index' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like "API Authenticatable"

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

    def do_request(options = {})
      get "/api/v1/questions", { format: :json }.merge(options)
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
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question)}

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

      context 'with answers' do
        it 'included' do
          expect(response.body).to have_json_size(2).at_path("question/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "questions answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'with comments' do
        it 'included' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "questions comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'with attachments' do
        it 'included' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(url).each do |attr|
          it "questions attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
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
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:create_valid_question) {post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }

      context 'with valid attributes' do
        it 'expect success status' do
          create_valid_question
          expect(response).to be_success
        end

        it 'creates new question' do
          expect { create_valid_question }
            .to change(Question, :count).by(1)
        end

        it 'assigns question to user' do
          create_valid_question
          expect(assigns(:question).user).to eq User.find(access_token.resource_owner_id)
        end
      end

      context 'with invaid attributes' do
        let(:create_invalid_question) {post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question) }

        it 'does not return success' do
          create_invalid_question 
          expect(response).to_not be_success
        end

        it 'has errors in response' do
          create_invalid_question
          expect(response.body).to have_json_path("errors")
        end

        it "doesn't save the question" do
          expect { create_invalid_question }
            .to_not change(Question, :count)
        end
      end
    end
  end
end

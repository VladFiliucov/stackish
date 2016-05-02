require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}

  describe 'GET #index' do
    it 'populates array of answers for a question' do
      question = create(:question)
      answer1 =  create(:answer, question: question, user: user)
      answer2 =  create(:answer, question: question, user: user)
      get :index, question_id: question
      expect(assigns(:answers)).to match_array([answer1, answer2])
    end
  end


  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'redirects to sign up page' do
        post :create, question_id: question, user: nil, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Logged in user' do
    login_user
    describe 'GET #new' do
      before { get :new, question_id: question.id}

      it 'assigns new answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves new answer to the database' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer)
          }.to change(question.answers, :count).by(1)
        end

        it 'redirects to tickets show view' do
          post :create, question_id: question, answer: attributes_for(:answer)
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {post :create, question_id: question, answer: attributes_for(:blank_answer)}.to_not change(Answer, :count)
        end

        it 're-renders new template' do
          post :create, question_id: question, answer: attributes_for(:blank_answer)
          expect(response).to redirect_to question_path(question)
        end
      end
    end
  end
end

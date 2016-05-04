require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}

  describe 'GET #index' do
    let(:question) { create(:question) }
    let(:user_answers) { create_list(:answer, 2, question: question) }

    it 'populates array of answers for a question' do
      get :index, question_id: question
      expect(assigns(:answers)).to match_array(user_answers)
    end
  end


  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'redirects to sign up page' do
        post :create, question_id: question, answer: attributes_for(:answer)
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

        it 'adds new answer to cerrent user answers' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer)
          }.to change(@user.answers, :count).by(1)
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
          expect(response).to render_template 'questions/show'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'author' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes question' do
        expect {delete :destroy, question_id: question, id: answer}.to change(Answer, :count).by(-1)
      end

      it 're-renders question path' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to(question)
      end
    end

    context 'not author' do
      login_user

      let(:owner) {create(:user)}

      it 'does not delete answer' do
        question = create(:question)
        answer = create(:answer, question: question)
        expect { delete :destroy, question_id: question, id: answer }.to_not change(Answer, :count)
      end
    end
  end
end

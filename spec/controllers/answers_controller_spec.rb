require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}

  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'redirects to sign up page' do
        post :create, question_id: question, format: :js, answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'Logged in user' do
    login_user

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves new answer to the database' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer), format: :js
          }.to change(question.answers, :count).by(1)
        end

        it 'adds new answer to cerrent user answers' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer), format: :js
          }.to change(@user.answers, :count).by(1)
        end

        it 'render create template'  do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {post :create, question_id: question, answer: attributes_for(:blank_answer), format: :js}.to_not change(Answer, :count)
        end

        it 're-renders create template' do
          post :create, question_id: question, answer: attributes_for(:blank_answer), format: :js
          expect(response).to render_template :create
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

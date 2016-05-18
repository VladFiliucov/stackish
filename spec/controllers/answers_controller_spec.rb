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
        let(:new_answer) { create(:answer, question: question) }

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


        it 'has best_answer set to false by default' do
          expect(new_answer).to_not be_best_answer
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

    describe 'PATCH #update' do
      let!(:answer) { create(:answer, question: question) }

      it 'assings the requested answer to @answer', format: :js do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :json
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :json
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'It has to be a really long body because i have length validation'}, format: :json
        answer.reload
        expect(answer.body).to eq 'It has to be a really long body because i have length validation'
      end

      context 'With Invalid attributes' do
        it 'does not updates answer' do
          patch :update, xhr: true, question_id: question, id: answer, answer: attributes_for(:blank_answer), format: :json
          answer.reload
          expect(answer.body).not_to be_empty
          expect(response.status).to eq(422)
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
        expect {delete :destroy, question_id: question, id: answer, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'returns success status' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response.status).to eq(200)
      end
    end

    context 'not author' do
      login_user
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete answer' do
        expect { delete :destroy, question_id: question, id: answer }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #mark_best' do
    login_user
    let!(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    context 'without best answer' do
      it 'displays answers in default order' do
        expect(question.answers.order(best_answer?: :desc)).to be == [answer1, answer2]
      end
    end

    context 'with best answer' do
      let(:best_answer) { create(:answer, question: question, best_answer?: true) }

      it 'displays answers with best standing first in order' do
        expect(question.answers.order(best_answer?: :desc)).to be == [best_answer, answer1, answer2]
      end

      context 'new best answer' do
        it 'resets previous best answers best_answer? attribute to false' do
          best_answer
          answer2.mark_best!
          best_answer.reload
          expect(best_answer.best_answer?).to be false
        end

        it 'sets best_answer? for the new best_answer to true' do
          expect{answer2.mark_best!}.to change{answer2.best_answer?}.from(false).to(true)
        end
      end
    end
  end
end

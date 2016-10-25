require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it_behaves_like "unauthorized entry" do
    let(:entry_params) { {comment: attributes_for(:comment)} }
  end

  describe 'Logged in user' do
    login_user

    describe 'POST #create' do
      context 'with invalid attributes' do
        it 'does not save blank comments' do
          expect {post :create, commentable: 'questions', question_id: question, comment: attributes_for(:blank_comment)}.
            to_not change(Comment, :count)
        end
      end

      context 'with valid attributes' do
        it 'saves valid comment for question' do
          expect {post :create, commentable: 'questions', question_id: question, comment: attributes_for(:comment)}.
            to change(question.comments, :count).by(1)
        end

        it 'saves valid comment for answer' do
          expect {post :create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment)}.
            to change(answer.comments, :count).by(1)
        end
      end
    end
  end

end

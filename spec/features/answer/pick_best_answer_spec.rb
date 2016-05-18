require 'features/features_helper'

feature 'Pick best answer', %{
  To help other people to find appropriate solution
  As an author of the question
  I want to be able to mark an answer as the best one
} do

  given(:user) { create(:user) }
  given(:not_question_owner) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }
  given!(:answer3) { create(:answer, question: question) }

  scenario 'As a guest user' do
    visit question_path(question)
    expect(page).to_not have_content("Mark Best")
  end

  context 'As a signed up user' do
    context 'Owner of question' do

      scenario 'Can pick answer as the best one' do
        sign_in(user)
        visit question_path(question)
        within("#mark_best_answer#{answer2.id}") do
          click_link('Mark Best')
        end

        expect(page).to have_css("div#answer-answer_#{answer2.id}.best_answer")
        expect(page).to have_content "You have picked best answer!"
      end

      scenario 'Can pick another answer as the best one' do
      end
    end

    scenario 'Not owner' do
      sign_in(not_question_owner)
      visit question_path(question)

      expect(page).to_not have_content("Mark Best")
    end
  end
end

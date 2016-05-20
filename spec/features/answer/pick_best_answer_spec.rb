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
      before do
        sign_in(user)
        visit question_path(question)
        within("#mark_best_answer#{answer2.id}") do
          click_link('Mark Best')
        end
      end

      scenario 'Can pick answer as the best one', js: true do
        expect(page).to have_content "You have picked best answer!"
        expect(page).to_not have_css "#mark_best_answer#{answer2.id}"
        within("#answer-answer_#{answer2.id}") do
          expect(page).to_not have_content "Mark Best"
        end
      end

      scenario 'Can pick another answer as the best one' do
      end

      scenario 'Best answer is displayed first on the page' do
      end
    end

    scenario 'Not owner' do
      sign_in(not_question_owner)
      visit question_path(question)

      expect(page).to_not have_content("Mark Best")
    end
  end
end

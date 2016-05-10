require "features/features_helper"

feature 'Editing answer', %{
  In order to fix a mistake
  As author of answer
  I want to be able to edit my answer
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given(:user_with_no_answers) {create(:user)}

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end

  describe 'Authenticated but not author' do
    before do
      sign_in(user_with_no_answers)
      visit question_path(question)
    end

    scenario 'Authenticated user can not see link to edit answers of others' do
      expect(page).to_not have_link('Edit Answer')
    end

    scenario 'Authenticated user tries to edit not his answer'
  end

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees edit(his answer) link' do
      expect(page).to have_link('Edit Answer')
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit Answer'
      within '.edit-answer' do
        fill_in 'New Answer', with: "Even better answer for a really important question"
      end
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content "Even better answer for a really important question"
      expect(page).to_not have_selector "textarea"
    end
  end
end

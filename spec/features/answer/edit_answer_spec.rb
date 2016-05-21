require "features/features_helper"

feature 'Editing answer', %{
  In order to fix a mistake
  As author of answer
  I want to be able to edit my answer
} do

  given!(:user) {create(:user)}
  given!(:question) {create(:question)}
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

    scenario 'Can not see link to edit answers of others' do
      expect(page).to_not have_link('Edit Answer')
    end
  end

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see edit(his answer) link' do
      expect(page).to have_link('Edit Answer')
    end

    describe 'Edits his answer', js: true do
      scenario 'With valid attributes', js: true do
        within ".answers" do
          find_link("Edit Answer").trigger('click')
          expect(page).to have_selector "textarea"
          fill_in 'Edit my Answer', with: "Even better answer for a really important question asdasdasdasd"
          click_on 'Edit'
        end

        expect(page).to_not have_content answer.body
        expect(page).to have_content "Even better answer for a really important question"
        within '.answers' do
          expect(page).to_not have_selector "textarea"
        end
      end

      scenario 'With invalid attributes', js: true do
        within ".answers" do
          find_link("Edit Answer").trigger('click')
          fill_in 'Edit my Answer', with: ""
          click_on 'Edit'
        end

        expect(page).to have_content "is too short"
        expect(page).to have_content answer.body
        within "#answer-answer_#{answer.id}" do
          expect(page).to have_selector "textarea"
        end
      end
    end
  end
end

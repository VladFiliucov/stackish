require 'features/features_helper'

feature 'Editing question', %{
  In order to correct my question
  As author of the question
  I want to edit my answer
} do

  given(:author) { create(:user) }
  given(:not_owner) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_content "Edit Question"
  end

  describe 'Authenticated but not author' do
    before do
      sign_in(not_owner)
    end

    scenario 'Can not see link to edit question' do
      visit question_path(question)

      expect(page).to_not have_content "Edit Question"
    end
  end

  describe 'Author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Can see edit link' do
      expect(page).to have_content "Edit Question"
    end

    describe 'Edits his answer', js: true do
      before do
        click_link "Edit Question"
      end

      scenario 'With valid attributes' do
        fill_in "Title", with: "This is a titile for tremendous question"
        fill_in "Question", with: "12345678901234567890"
        click_button "Ask"

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content "This is a titile for tremendous question"
        expect(page).to have_content "has been updated"
      end

      scenario 'With invalid attributes'  do
        fill_in "Title", with: "Title for an invalid question"
        fill_in "Question", with: ""
        click_button "Ask"

        expect(page).to_not have_content "Title for an invalid question"
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content "too short"
      end
    end
  end
end

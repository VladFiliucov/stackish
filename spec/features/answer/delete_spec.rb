require 'features/features_helper'

feature 'delete answer', %{
  In order to stop helping people
  As an authenticated owner of answer
  I want to be able to delete my answer
} do

  given!(:owner) {create(:user)}
  given!(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, user: owner, body: "This answer soon will be gone.")}
  given!(:user) {create(:user)}

  scenario 'Author deletes his answer', js: true do
    sign_in(owner)

    visit question_path(question)
    expect(page).to have_content  "This answer soon will be gone."
    click_on 'Delete My Answer'

    expect(page).to have_content 'has been deleted'
    expect(page).to_not have_content "This answer soon will be gone."
  end

  scenario 'User without own answers can not see delete button' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content  "This answer soon will be gone."
    expect(page).to_not have_content 'Delete My Answer'
  end
end

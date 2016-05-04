require 'rails_helper'

feature 'delete question', %{
  To get rid of stupid question
  As an authenticated user
  I want to be ableto delete my questions
} do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given(:not_owner) {create(:user)}

  scenario 'Author deletes his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete Question'

    expect(page).to have_content 'has been deleted'
  end

  scenario '!owner can not see delete question button' do
    sign_in(not_owner)

    visit question_path(question)

    expect(page).to_not have_content 'Delete Question'
  end
end

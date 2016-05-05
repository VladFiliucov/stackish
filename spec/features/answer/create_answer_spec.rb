require 'rails_helper'

feature 'create answer', %{
  To answer someones question
  As an authenticated user
  I want to be able to create answer for a question
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'Logged in user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'My Answer', with: 'Bloody marvelous answer for this stupid question! lajksjdkahsljdka'
    click_on 'Answer'

    expect(page).to have_content 'Your answer was successfully posted.'
    expect(page).to have_content 'Bloody marvelous answer'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'My Answer', with: ''
    click_on 'Answer'

    expect(page).to have_content 'sign in or sign up'
  end
end

require 'rails_helper'

feature 'create question', %{
  To get answer for my question
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Logged in user creates question' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Super question'
    fill_in 'Body', with: 'Bloody marvelous content'
    click_on 'Ask'

    expect(page).to have_content 'Your question was successfully posted.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit '/questions'
    click_on 'Ask question'

    expect(page).to have_content 'sign in or sign up'
  end
end


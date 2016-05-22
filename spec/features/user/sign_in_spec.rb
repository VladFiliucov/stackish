require 'features/features_helper'

feature 'User sign in', %q{
  In order to ask questions
  As a user
  I want to be able to sign up
} do

  given(:user) {create(:user)}
  
  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content('Signed in successfully')
    expect(current_path).to eq(root_path)
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: 'nonexistinguser'
    click_on 'Log in'
    
    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq(new_user_session_path)
  end
end


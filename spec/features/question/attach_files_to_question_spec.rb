require "features/features_helper"

feature 'Attach file to question', %q{
  In order to illustrate my question
  As an owner of the question
  I want to be able to attach files to my question
} do
  
  given(:user) { create(:user) }

  context 'Logged in user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User attaches file on question creation' do
      fill_in 'Title', with: "This is a title for a new question"
      fill_in 'Body', with: "This the question in details itself, and few more lines"
      attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'Can delete attachments from the question'
  scenario 'Can attach multiple files to question'

  context 'User not owner'
  scenario 'Can not see add attachemnt to question button'
  scenario 'Can not see delete questions attachment button'
  context 'Non Signed up user'
end

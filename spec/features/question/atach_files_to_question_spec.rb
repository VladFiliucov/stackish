require "features/features_helper"

feature 'Attach file to question', %q{
  In order to illustrate my question
  As an owner of the question
  I want to be able to attach files to my question
} do
  
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User attaches file on question creation' do
    fill_in 'Title', with: "This is a title for a new question"
    fill_in 'Body', with: "This the question in details itself, and few more lines"
    attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Ask'

    expect(page).to have_content 'rails_helper.rb'
  end
end

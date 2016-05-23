require "features/features_helper"

feature 'Attach file to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to be able to attach files to my answer
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User attaches file on question creation', js: true do
    fill_in 'My Answer', with: "This is a answer for the question"
    attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Answer'

    within ".answers" do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end

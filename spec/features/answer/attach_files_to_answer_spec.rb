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
    fill_in 'My Answer', with: "This is a answer for the question"
    attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
  end

  scenario 'User attaches file on question creation', js: true do
    click_on 'Answer'

    within ".answers" do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'User can attach multiple files to his answer', js: true do
    click_on 'Attach File'
    within all(:css, ".nested-fields").last do
      attach_file "File", "#{Rails.root}/app/models/question.rb"
    end
    click_on 'Answer'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'question.rb', href: '/uploads/attachment/file/2/question.rb'
  end

  scenario 'User can delete attachments', js: true do
    click_on 'Delete Attachment'

    expect(page).to_not have_content("rails_helper.rb")
  end
end

require "features/features_helper"

feature 'Attach file to question', %q{
  In order to illustrate my question
  As an owner of the question
  I want to be able to attach files to my question
} do

  given(:user) { create(:user) }
  let(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Non Signed up user' do
    scenario 'Can not see links to delete orr add attachments' do
      visit question_path(question)

      within "#question_#{question.id}" do
        expect(page).to_not have_content "Delete Attachment"
        expect(page).to_not have_content "Add Attachment"
      end
    end
  end
  
  context 'User not owner' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'Can not see add or delete attachemnt link' do
      within "#question_#{question.id}" do
        expect(page).to_not have_content "Delete File"
        expect(page).to_not have_content "Add File"
      end
    end
  end

  context 'Logged in user' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: "This is a title for a new question"
      fill_in 'Body', with: "This the question in details itself, and few more lines"
    end

    scenario 'Can attach multiple files to question on creation', js: true do
      within ".nested-fields" do
        attach_file "File", "#{Rails.root}/spec/features/features_helper.rb"
      end

      click_on 'Add Attachment'
      within all(:css, ".nested-fields").last do
        attach_file "File", "#{Rails.root}/app/models/question.rb"
      end
      click_on 'Ask'

      expect(page).to have_link 'features_helper.rb', href: '/uploads/attachment/file/1/features_helper.rb'
      expect(page).to have_link 'question.rb', href: '/uploads/attachment/file/2/question.rb'
    end

    scenario 'Can delete attachments from the question', js: true do
      attach_file "File", "#{Rails.root}/spec/features/features_helper.rb"
      click_on "Ask"
      click_on "Delete File"
      expect(page).to_not have_content "rails_helper.rb"
    end

    context 'Owner' do
      background do
        attach_file "File", "#{Rails.root}/spec/features/features_helper.rb"
        click_on 'Ask'
        click_on "Edit Question"
      end

      scenario 'Can see links to add and delete attachments', js: true do
        expect(page).to have_link("Add Attachment")
        expect(page).to have_link("Delete Attachment")
      end

      scenario 'Can delete attachment', js: true do
        within ".question-container" do
          click_on 'Delete Attachment'
          click_on 'Ask'
        end

        expect(page).to_not have_content("features_helper.rb")
      end

      scenario 'Can change attachment to another one', js: true do
        within all(:css, ".nested-fields").first do
          attach_file "File", "#{Rails.root}/app/models/question.rb"
        end
        click_on 'Ask'

        expect(page).to_not have_content("features_helper.rb")
        expect(page).to have_content("question.rb")
      end
    end
  end
end

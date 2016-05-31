require "features/features_helper"

feature 'Attach file to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to be able to attach files to my answer
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Owner' do
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

  context 'Already existing Answer' do
    let!(:another_question) { create(:question) }
    let!(:answers_author) { create(:user) }
    let!(:answer) { create(:answer, question: another_question, user: answers_author) }

    before do
      sign_in(answers_author)
      visit question_path(another_question)
      click_on 'Edit Answer'
      within "#edit-answer-#{answer.id}" do
        click_on 'Attach File'
        attach_file "File", "#{Rails.root}/app/models/answer.rb"
      end
      click_on 'Edit'
    end

    scenario 'Can attach files after answer is created', js: true do
      expect(page).to have_content("answer.rb")
    end

    scenario 'Can delete attachment of existing answer', js: true do
      within "#edit-answer-#{answer.id}" do
        click_on('Delete File')
      end
      click_on 'Edit'

      expect(page).to_not have_content("answer.rb")
    end
  end
end

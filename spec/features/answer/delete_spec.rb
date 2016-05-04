require 'rails_helper'

feature 'delete answer', %{
  In order to stop helping people
  As an authenticated owner of answer
  I want to be able to delete my answer
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'Author deletes his answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'My Answer', with: "123123123123123123123123123123123123123"
    click_on 'Answer'
    expect(page).to have_content 'was successfully posted'
    click_on 'Delete My Answer'

    expect(page).to have_content 'has been deleted'
  end
end

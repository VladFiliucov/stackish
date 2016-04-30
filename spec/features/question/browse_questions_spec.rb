require 'rails_helper'

feature 'browse question list', %{
  In order to browse questions
  As any kind of user
  I want to be able to se questions listing.
} do

  let!(:question1) { create(:question, title: "Question 1") }
  let!(:question2) { create(:question, title: "Question 2") }

  scenario 'User can browse question list' do
    visit '/questions'

    expect(page).to have_content "Question 1"
    expect(page).to have_content "Question 2"
  end

  scenario 'Non-authenticated user can view question page.' do
    visit '/questions'

    expect(page).to have_content "Question 2"
    click_link("Question 2")
    expect(page).to have_content "This is a realy long description beacuse it has to be 20 chars long."
  end
end

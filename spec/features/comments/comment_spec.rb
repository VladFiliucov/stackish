require 'features/features_helper'

feature 'comment question/answer', %{
  In order to give more precise answers
  As a logged in user
  I want to be able to leave comments
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer) { create(:answer, question: question) }

  scenario 'Logged in user comments question', js: true do
    sign_in(user)

    visit question_path(question)
    within("#question_#{question.id}_comment_form") do
      fill_in 'Comment', with: 'Comment for a stupid question'
      click_on 'Comment'
    end

    expect(page).to have_content 'Comment for a stupid question'
  end

  scenario 'Non-authenticated user tries to comment question' do
    visit question_path(question)

    expect(page).to_not have_button 'Comment'
  end

  scenario 'User tries to create invalid question comment', js: true do
    sign_in(user)
    visit question_path(question)

    within("#question_#{question.id}_comment_form") do
      fill_in 'Comment', with: 'YES!'
      click_on 'Comment'
    end

    expect(page).to_not have_content "YES!"
  end

  scenario 'User tries to create invalid answer comment', js: true do
    sign_in(user)

    visit question_path(question)
    within("#answer_#{answer.id}_comment_form") do
      fill_in 'Comment', with: 'YES!'
      click_on 'Comment'
    end

    expect(page).to_not have_content "YES!"
  end

  scenario 'Logged in user comments answer', js: true do
    sign_in(user)

    visit question_path(question)
    within("#answer_#{answer.id}_comment_form") do
      fill_in 'Comment', with: 'Comment for a stupid question'
      click_on 'Comment'
    end

    expect(page).to have_content 'Comment for a stupid question'
  end
end

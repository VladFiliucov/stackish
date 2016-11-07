require 'features/features_helper'

feature 'search data', %{
  In order to find relevant data
  As any user
  I want to be able to search for questions answers comments and users
} do

  given!(:user) {create(:user, email: "awesomeuser@gmail.com")}
  given!(:question) {create(:question, user: user, title: "questions title is including word search to be found")}
  given!(:answer) {create(:answer, question: question, body: "answers body is including word search to be found")}
  given!(:questions_comment) {create(:comment, commentable: question, body: "questions comment body is including word search to be found")}
  given!(:answers_comment) {create(:comment, user: user, commentable: answer, body: "answers comment body is including word search to be found")}

  before do
    User.reindex
    Question.reindex
    Answer.reindex
    Comment.reindex
    visit "/"
  end

  context 'bulk search' do
    scenario 'can search all models' do
      fill_in 'search_word_field', with: 'search'
      click_button "Search"
      expect(page).to have_content "questions title"
      expect(page).to have_content "answers body"
      expect(page).to have_content "questions comment"
      expect(page).to have_content "answers comment"
    end

    scenario 'does not include extra data' do
      fill_in 'search_word_field', with: 'comment'
      click_button "Search"
      expect(page).to_not have_content "questions title"
      expect(page).to_not have_content "answers body"
      expect(page).to have_content "questions comment"
      expect(page).to have_content "answers comment"
    end

    scenario 'is displaying all users entries' do
      fill_in 'search_word_field', with: 'awesomeuser'
      click_button 'Search'
      expect(page).to have_content "questions title"
      expect(page).to_not have_content "answers title"
    end
  end

  context 'by model search' do
    scenario 'can search by question' do
      fill_in 'search_word_field', with: 'search'
      select 'Question', from: "model-type-select"
      click_button 'Search'
      expect(page).to have_content "questions title"
      expect(page).to_not have_content "answers title"
    end

    scenario 'can search by answer' do
      fill_in 'search_word_field', with: 'search'
      select 'Answer', from: "model-type-select"
      click_button 'Search'
      expect(page).to_not have_content "questions title"
      expect(page).to have_content "answers body"
    end

    scenario 'can search by comment' do
      fill_in 'search_word_field', with: 'search'
      select 'Comment', from: "model-type-select"
      click_button 'Search'
      expect(page).to_not have_content "questions title"
      expect(page).to_not have_content "answers body"
      expect(page).to have_content "questions comment"
      expect(page).to have_content "answers comment"
    end

    scenario 'can search by user (displaying only questions and answers)' do
      fill_in 'search_word_field', with: 'awesomeuser'
      select 'User', from: "model-type-select"
      click_button 'Search'
      expect(page).to have_content "questions title"
      expect(page).to_not have_content "answers body"
      expect(page).to_not have_content "questions comment"
      expect(page).to_not have_content "answers comment"
    end

    scenario 'search results are links to question where they where found' do
      fill_in 'search_word_field', with: "search"
      click_button 'Search'
      click_link question.title
      expect(page).to have_content question.body
    end

    scenario 'comment search results lead to comments question' do
      fill_in 'search_word_field', with: "search"
      select 'Comment', from: "model-type-select"
      click_button 'Search'
      click_link "questions comment body is including word search to be found"
      expect(page).to have_content question.body
      expect(page).to have_content questions_comment.body
    end
  end
end

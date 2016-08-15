require 'features/features_helper'

feature 'rate question', %{
  To improve overall application user experience
  As an authenticated user
  I want to be able to rate questions
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'guest user' do
    visit question_path(question)
    expect(page).to_not have_content 'Rate UP'
  end

  context 'question author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can not rate own question' do
      within ".question-container" do
        expect(page).to have_button("Increase Rating", disabled: true)
        expect(page).to have_button("Decrease Rating", disabled: true)
        expect(page).to_not have_content("Withdraw Rating")
      end
    end
  end

  context 'regular user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can increase questions rating', js: true do
      within ".question-container" do
        expect(page).to have_content("Current Rating: 0")
        click_link("Increase Rating")
        expect(page).to have_content("Current Rating: 1")
      end
    end

    scenario 'can increase rating only once', js: true do
      within ".question-container" do
        expect(page).to have_content("Current Rating: 0")
        click_link("Increase Rating")
        click_link("Increase Rating")
        expect(page).to have_content("Current Rating: 1")
      end
    end

    scenario 'can withdraw his positive rating', js: true do
      within ".question-container" do
        expect(page).to_not have_button("Withdraw Rating")
        expect(page).to have_content("Current Rating: 0")
        click_link("Increase Rating")
        expect(page).to have_content("Current Rating: 1")
        click_link("Withdraw Rating")
        expect(page).to have_content("Current Rating: 0")
      end
    end

    scenario 'can decrease questions rating', js: true do
      within ".question-container" do
        expect(page).to have_content("Current Rating: 0")
        click_link("Decrease Rating")
        expect(page).to have_content("Current Rating: -1")
      end
    end

    scenario 'can decrease rating only once', js: true do
      within ".question-container" do
        expect(page).to have_content("Current Rating: 0")
        click_link("Decrease Rating")
        click_link("Decrease Rating")
        expect(page).to have_content("Current Rating: -1")
      end
    end

    scenario 'can withdraw his negative rating', js: true do
      within ".question-container" do
        expect(page).to_not have_link("Withdraw Rating")
        expect(page).to have_content("Current Rating: 0")
        click_link("Decrease Rating")
        expect(page).to have_content("Current Rating: -1")
        click_link("Withdraw Rating")
        expect(page).to have_content("Current Rating: 0")
      end
    end
  end

  context 'more than one user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within ".question-container" do
        click_link('Increase Rating')
      end
      click_link("Logout")
    end

    scenario 'second user can increase already positive rating', js: true do
      sign_in(second_user)
      visit question_path(question)
      within ".question-container" do
        expect(page).to have_content("Current Rating: 1")
        click_link("Increase Rating")
        expect(page).to have_content("Current Rating: 2")
      end
    end
  end
end

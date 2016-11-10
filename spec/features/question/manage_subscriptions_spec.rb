require 'features/features_helper'

feature 'manage subscriptions', %{
  To get most recent information
  As an authenticated user
  I want to be able to subscribe/unsubscribe to questions
} do

  given(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'guest user' do
    visit question_path(question)
    expect(page).to_not have_button("Subscribe")
    expect(page).to_not have_button("Unsubscribe")
  end

  context'author' do
    before do
      sign_in(user)

      visit 'questions'
      click_on 'Ask Question'
      fill_in 'Title', with: 'Super question'
      fill_in 'Body', with: 'Bloody marvelous content'
      click_on 'Ask'
    end

    scenario 'has unsubscribe button after creating a question' do
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'can unsubscribe after creating', js: true do
      click_link 'Unsubscribe'
      expect(page).to have_content("Subscribe")
    end
  end

  context 'unsubscribed user' do
    before do
      sign_in(user)

      visit question_path(question)

      scenario 'Can see Subscribe button when no subscription' do
        expect(page).to have_content 'Subscribe'
      end

      scenario 'Can subscribe for question updates', js: true do
        click_on "Subscribe"

        expect(page).to have_content("Unsubscribe")
      end
    end
  end
end

require 'features/features_helper'

feature 'Login with social-network account', %{
  To sign up faser and evade extra passwords remebering
  As a non-authenticated user
  I want to be able to sign up with my social network account
} do

  describe "access top page" do
    it "can sign in user with Twitter account" do
      visit '/users/sign_up'
      expect(page).to have_content("Sign in with Twitter")
      mock_auth_hash('twitter')
      click_link "Sign in with Twitter"
      expect(page).to have_content("Successfully authenticated from Twitter account")
      expect(page).to have_content("Logout")
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit '/users/sign_up'
      expect(page).to have_content("Sign in with Twitter")

      click_link "Sign in with Twitter"

      expect(page).to have_content('Could not authenticate')
      expect(page).to have_content('Invalid credentials')
    end
  end
end

require 'features/features_helper'

feature 'Login with social-network account', %{
  To sign in faser and evade extra passwords remebering
  As a non-authenticated user
  I want to be able to sign up with my social network account
} do

  describe "access top page" do
    before(:each) do
      OmniAuth.config.mock_auth[:twitter] = nil
      OmniAuth.config.mock_auth[:facebook] = nil
    end

    context 'from sign up page' do
      it "can sign in user with Twitter account" do
        visit '/users/sign_up'
        expect(page).to have_content("Sign in with Twitter")
        mock_auth_hash('twitter')
        click_link "Sign in with Twitter"
        expect(page).to have_content("Successfully authenticated from Twitter account")
        expect(page).to have_content("Logout")
      end

      it "can handle authentication error from twitter" do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
        visit '/users/sign_up'
        expect(page).to have_content("Sign in with Twitter")

        click_link "Sign in with Twitter"

        expect(page).to have_content('Could not authenticate')
        expect(page).to have_content('Invalid credentials')
      end

      it "can sign in user with Facebook account" do
        visit '/users/sign_up'
        expect(page).to have_content("Sign in with Facebook")
        mock_auth_hash('facebook')
        click_link "Sign in with Facebook"
        expect(page).to have_content("Successfully authenticated from Facebook account")
        expect(page).to have_content("Logout")
      end

      it "can handle authentication error from facebook" do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        visit '/users/sign_up'
        expect(page).to have_content("Sign in with Facebook")

        click_link "Sign in with Facebook"

        expect(page).to have_content('Could not authenticate')
        expect(page).to have_content('Invalid credentials')
      end
    end

    context 'from sign in page' do
      it "can sign in user with Twitter account" do
        visit '/users/sign_in'
        expect(page).to have_content("Sign in with Twitter")
        mock_auth_hash('twitter')
        click_link "Sign in with Twitter"
        expect(page).to have_content("Successfully authenticated from Twitter account")
        expect(page).to have_content("Logout")
      end

      it "can handle authentication error from twitter" do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
        visit '/users/sign_in'
        expect(page).to have_content("Sign in with Twitter")

        click_link "Sign in with Twitter"

        expect(page).to have_content('Could not authenticate')
        expect(page).to have_content('Invalid credentials')
      end

      it "can sign in user with Facebook account" do
        visit '/users/sign_in'
        expect(page).to have_content("Sign in with Facebook")
        mock_auth_hash('facebook')
        click_link "Sign in with Facebook"
        expect(page).to have_content("Successfully authenticated from Facebook account")
        expect(page).to have_content("Logout")
      end

      it "can handle authentication error from facebook" do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        visit '/users/sign_in'
        expect(page).to have_content("Sign in with Facebook")

        click_link "Sign in with Facebook"

        expect(page).to have_content('Could not authenticate')
        expect(page).to have_content('Invalid credentials')
      end
    end
  end
end

require 'rails_helper'

feature "Signing out" do

  given(:user) { create(:user) }

  it "allows signed in user to sign out" do
    sign_in(user)
    visit(root_path)

    expect(page).to have_content("Sign Out")
    click_link("Sign Out")
    expect(page).to_not have_content("Sign Out")
    expect(page).to have_content("Sign In")
  end
end

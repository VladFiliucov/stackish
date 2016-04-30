require 'rails_helper'

feature "Signing out" do

  given(:user) { create(:user) }

  it "allows signed in user to sign out" do
    sign_in(user)
    visit(root_path)

    expect(page).to have_content("Logout")
    click_link("Logout")
    expect(page).to_not have_content("Logout")
    expect(page).to have_content("Login")
  end
end

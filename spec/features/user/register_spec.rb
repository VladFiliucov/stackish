require "rails_helper"

feature "Registration" do
  it "allows a user to signup." do
    expect(User.count).to eq(0)

    visit root_path
    expect(page).to have_content("Sign Up")
    click_link("Sign Up")

    fill_in "Email", with: "uniqemail@example.com"
    fill_in "Password", with: "SuperPassword123"
    fill_in "Password confirmation", with: "SuperPassword123"
    click_button "Sign up"

    expect(page).to have_content "Logout"
  end
end

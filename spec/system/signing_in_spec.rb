require "rails_helper"

RSpec.describe "accounts" do
  before do
    create(:customer, email: "test@tester.com", password: "Welkom123!")
  end

  scenario "return to the previous path after sign in" do
    visit "/"

    expect(page).to have_current_path("/customers/sign_in")

    within "#new_customer" do
      fill_in "Email", with: "test@tester.com"
      fill_in "Password", with: "Welkom123!"
      click_button "Log in"
    end

    expect(page).to have_current_path("/")

    click_on "Send new transfer"

    expect(page).to have_current_path("/transactions/new")
  end
end

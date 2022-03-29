require "rails_helper"

RSpec.describe "transactions" do
  let(:customer) do
    create(:customer, email: "test@tester.com", password: "Welkom123!")
  end

  before do
    create(:transaction, :credit, :recalculate_balance,
           amount_cents: 100_00, receiver: customer)
    create(:customer, email: "test2@tester.com", account_number: "ABNA0444")

    login_as(customer)
    visit "/transactions/new"
  end

  scenario "creates a transaction and shows message" do
    within "#new_transaction" do
      fill_in "transaction[base_amount]", with: "20"
      fill_in "transaction[decimal_amount]", with: "95"
      fill_in "transaction[account_number]", with: "ABNA0444"
      fill_in "transaction[account_holder]", with: "T2. Tester"

      click_button "Send!"
    end

    expect(page).to have_current_path("/")
    expect(page).to have_content("Transaction sent")
  end

  context "with errors" do
    scenario "shows basic validation messages" do
      within "#new_transaction" do
        fill_in "transaction[base_amount]", with: "20"
        fill_in "transaction[decimal_amount]", with: ""
        fill_in "transaction[account_number]", with: "ABNAwrong"
        fill_in "transaction[account_holder]", with: ""

        click_button "Send!"
      end

      expect(page).to have_current_path("/transactions")
      expect(page).to have_content("Account number not found")
      expect(page).to have_content("Account holder can't be blank")
    end

    scenario "shows balance error message" do
      within "#new_transaction" do
        fill_in "transaction[base_amount]", with: "101"
        fill_in "transaction[decimal_amount]", with: "0"
        fill_in "transaction[account_number]", with: "ABNA0444"
        fill_in "transaction[account_holder]", with: "T2. Tester"

        click_button "Send!"
      end

      expect(page).to have_current_path("/transactions")
      expect(page).to have_content("Not enough balance")
    end
  end
end

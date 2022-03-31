require "rails_helper"

RSpec.describe Customer do
  subject(:customer) { build(:customer, balance_cents: 20_00) }

  describe ".transactions" do
    before do
      customer.save!

      create(:transaction, :credit, receiver: customer, amount_cents: 50_00)
      create(:transaction, :transfer, sender: customer, amount_cents: 10_00)
    end

    it "contains a credit and transfer transaction" do
      expect(customer.transactions.count).to be(2)
    end
  end

  describe ".balance" do
    it "automatically updates balance_cents when balance is updates" do
      customer.balance += Money.from_cents(20_00)

      expect(customer.balance_cents).to be(40_00)
    end
  end
end

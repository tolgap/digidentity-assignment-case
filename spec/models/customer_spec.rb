require "rails_helper"

RSpec.describe Customer do
  subject(:customer) { build(:customer) }

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
end

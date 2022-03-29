require "rails_helper"

RSpec.describe TransferService do
  subject(:service) do
    described_class.new(sender:, receiver:)
  end

  let(:sender) { create(:customer) }
  let(:receiver) { create(:customer) }

  before do
    create(:transaction, :credit, :recalculate_balance, amount_cents: 100_00, receiver: sender)
  end

  describe ".transfer_money" do
    it "creates a new transfer transaction" do
      transaction = service.transfer_amount!(amount_cents: 50_00)

      expect(transaction.amount).to eql_monetized(50_00)
      expect(transaction.receiver).to eq(receiver)
    end

    it "recalculates the balance of sender and receiver" do
      service.transfer_amount!(amount_cents: 20_00)

      sender.reload
      receiver.reload

      expect(sender.balance).to eql_monetized(80_00)
      expect(receiver.balance).to eql_monetized(20_00)
    end

    it "does not change balances if balance is not enough" do
      service.transfer_amount!(amount_cents: 100_01)

      sender.reload
      receiver.reload

      expect(sender.balance).to eql_monetized(100_00)
      expect(receiver.balance).to eql_monetized(0)
    end
  end
end

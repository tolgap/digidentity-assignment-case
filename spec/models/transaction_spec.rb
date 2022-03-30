require "rails_helper"

RSpec.describe Transaction do
  context "credit transaction" do
    subject(:transaction) do
      build(:transaction, :credit,
            receiver:, amount_cents: 25_00)
    end

    let(:receiver) { create(:customer, balance_cents: 50_00) }

    it "should call receiver.update_balance_atomic!" do
      expect(receiver).to receive(:update_balance_atomic!).with(amount_cents: 25_00)

      transaction.save
    end

    it "should not update customer balance if after_save fails" do
      expect(receiver).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      transaction.save
      receiver.reload

      expect(receiver.balance).to eql_monetized(50_00)
    end
  end

  context "transfer transaction" do
    subject(:transaction) do
      build(:transaction, :credit,
            receiver:, sender:, amount_cents: 25_00)
    end

    let(:sender) { create(:customer, balance_cents: 130_00) }
    let(:receiver) { create(:customer, balance_cents: 50_00) }

    it "should call .update_balance_atomic! on receiver and sender" do
      expect(sender).to receive(:update_balance_atomic!).with(amount_cents: -25_00)
      expect(receiver).to receive(:update_balance_atomic!).with(amount_cents: 25_00)

      expect(transaction.save).to be(true)
    end

    it "should not update customer balance if after_save fails" do
      expect(receiver).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      transaction.save
      sender.reload
      receiver.reload

      expect(sender.balance).to eql_monetized(130_00)
      expect(receiver.balance).to eql_monetized(50_00)
    end

    it "should not create transaction if customer balance update fails" do
      expect(receiver).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect(transaction.save).to be(false)
    end
  end
end

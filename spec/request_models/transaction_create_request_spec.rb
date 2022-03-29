require "rails_helper"

RSpec.describe TransactionCreateRequest do
  subject(:request) do
    described_class.new(
      base_amount: 20,
      decimal_amount: 50,
      account_number:
    )
  end

  let(:account_number) { Faker::Bank.iban(country_code: "nl") }

  context "with validations" do
    subject do
      request.valid?
      request.errors
    end

    it { is_expected.to have_key(:account_number) }
  end

  describe ".receiver" do
    subject(:receiver) { request.receiver }

    it { is_expected.to be_nil }

    it "is expected to match customer by account number" do
      customer = create(:customer, account_number:)
      expect(receiver).to eq(customer)
    end
  end

  describe ".amount" do
    subject { request.amount }

    it { is_expected.to be_monetized }
  end
end

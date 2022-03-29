class TransactionCreateRequest < BaseRequest
  attribute :base_amount, :integer
  attribute :decimal_amount, :integer
  attribute :currency, :string
  attribute :account_number, :string
  attribute :account_holder, :string

  validates :base_amount, numericality: { integer_only: true, greater_than: 0 }
  validates :decimal_amount, numericality: { integer_only: true, greater_than_or_equal_to: 0 }
  validates :account_number, presence: true
  validates :account_holder, presence: true
  validate :validate_receiver, if: -> { account_number.present? }

  def initialize(attrs = {})
    super
    self.currency ||= "EUR"
    self.base_amount ||= 0
    self.decimal_amount ||= 0
  end

  def amount
    Money.from_cents(amount_cents, currency)
  end

  def amount_cents
    base_amount * 100 + decimal_amount
  end

  def receiver
    @receiver ||= Customer.find_by(account_number:)
  end

  private

  def validate_receiver
    return if receiver

    errors.add(:account_number, :not_found)
    false
  end
end

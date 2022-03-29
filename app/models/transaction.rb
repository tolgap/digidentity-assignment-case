class Transaction < ApplicationRecord
  TYPE = %w[credit transfer].freeze

  belongs_to :sender,
             class_name: "Customer",
             inverse_of: :sent_transactions,
             optional: true

  belongs_to :receiver,
             class_name: "Customer",
             inverse_of: :received_transactions

  scope :credits, -> { where(transaction_type: "credit") }
  scope :transfers, -> { where(transaction_type: "transfer") }

  validates :transaction_type, inclusion: { in: TYPE }
  validates :amount_cents, numericality: { greater_than: 0, only_integer: true }
  validate :validate_sender_balance, if: :sender

  monetize :amount_cents, with_model_currency: :currency

  def validate_sender_balance
    return unless sender

    new_balance = sender.balance - amount
    return if new_balance >= 0

    errors.add(:base, "Not enough balance")
  end
end

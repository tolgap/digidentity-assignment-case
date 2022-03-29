class TransferService
  def initialize(sender:, receiver:)
    @sender = sender
    @receiver = receiver
  end

  def transfer_amount!(amount_cents:, currency: "EUR")
    transaction = Transaction.new(
      sender:, receiver:, amount_cents:, currency:, transaction_type: "transfer"
    )

    ActiveRecord::Base.transaction do
      if transaction.save
        sender.recalculate_balance!
        receiver.recalculate_balance!
      end
    end

    transaction
  end

  private

  attr_reader :sender, :receiver
end
